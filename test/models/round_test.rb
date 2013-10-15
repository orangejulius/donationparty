require 'test_helper'

class RoundTest < ActiveSupport::TestCase
  def setup
    @r = Round.new
  end

  test "newly created round has randomly generated url string" do
    stub_secure_random_hex(Round::URL_LENGTH / 2)
    r = Round.new

    assert_equal fake_random_hex(Round::URL_LENGTH), r.url
  end

  test "newly created round has expire time of one hour" do
    assert_not_nil @r.expire_time
    assert Time.now + 1.hours - @r.expire_time < 1 # fuzzy time comparison
  end

  test "url and expire_time persist on save" do
    @r.save
    r2 = Round.find_by url: @r.url

    assert_equal r2.url, @r.url

    assert_equal r2.expire_time, @r.expire_time
  end

  test "expire_time does not have miliseconds" do
    assert @r.expire_time.change(usec: 0) == @r.expire_time, "round.expire_time has milisecond precision"
  end

  test "seconds_left returns time until round expires" do
    r = Round.create

    round_duration = Rails.application.config.round_duration
    r.expire_time = Time.now + round_duration

    assert r.seconds_left - round_duration < 1
  end

  test "seconds_left is never negative" do
    @r.expire_time = Time.now - 2.hours
    assert_equal 0, @r.seconds_left
  end

  test "seconds_left has second precision" do
    assert_equal @r.seconds_left.round, @r.seconds_left
  end

  test "expired rounds automatically marked closed" do
    @r.expire_time = Time.now - Rails.application.config.round_duration - 1.hours

    assert_equal true, @r.closed
  end

  test "winner returns nil if no donations" do
    assert_nil @r.winner
  end

  test "winner returns donation with highest amount if round finished" do
    @r.save
    donations = []
    Rails.application.config.min_donations.times do |i|
      donations.append Donation.create(round: @r, amount: i, email: 'test@example.com')
    end

    assert_nil @r.winner

    @r.closed = true
    @r.save

    assert_equal donations.last, @r.winner
  end

  test "round failed if closed without enough donations" do
    round = Round.create(expire_time: Time.now - 1.hour)

    assert_equal true, round.failed

    donations = []
    Rails.application.config.min_donations.times do |i|
      donations.append Donation.create(round: round, amount: i, email: 'test@example.com')
    end

    assert_equal false, round.failed
  end

  test "total_raised returns total donation amount after round closes successfully" do
    assert_equal 0, @r.total_raised

    donations = []
    Rails.application.config.min_donations.times do |i|
      donations.append Donation.create(round: @r, amount: i, email: 'test@example.com')
    end

    assert_equal 0, @r.total_raised

    @r.closed = true

    assert_equal donations.inject(0) {|sum, d| sum + d.amount}, @r.total_raised
  end

  test "winner returns nil if round failed with not enough donations" do
    @r.save
    @donation = Donation.create(round: @round, email: 'test@example.com')

    @r.closed = true
    @r.save
    @r.reload

    assert_equal nil, @r.winner
  end

  test "notify subscribers triggers pusher event" do
    pusherMock = mock('Pusher')
    pusherMock.expects(:trigger).with(@r.url, 'new:charge', {})

    Round.any_instance.stubs(:realtime).returns(pusherMock)

    @r.notify_subscribers
  end
end
