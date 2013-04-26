require 'test_helper'

class RoundTest < ActiveSupport::TestCase
  test "newly created round has randomly generated url string" do
    stub_secure_random_hex(Round::URL_LENGTH / 2)
    r = Round.create

    assert_equal fake_random_hex(Round::URL_LENGTH), r.url
  end

  test "newly created round has expire time of one hour" do
    r = Round.create
    assert_not_nil r.expire_time
    assert Time.now + 1.hours - r.expire_time < 1 # fuzzy time comparison
  end

  test "url and expire_time persist on save" do
    r = Round.create

    r2 = Round.find_by_url(r.url)

    assert_equal r2.url, r.url
    assert_equal r2.expire_time, r.expire_time
  end

  test "seconds_left returns time until round expires" do
    r = Round.create

    round_duration = Rails.application.config.round_duration
    r.expire_time = Time.now + round_duration

    assert r.seconds_left - round_duration < 1
  end

  test "seconds_left is never negative" do
    r = Round.create

    r.expire_time = Time.now - 2.hours
    assert_equal 0, r.seconds_left
  end

  test "expired rounds automatically marked closed" do
    @r = Round.create
    @r.expire_time = Time.now - Rails.application.config.round_duration - 1.hours

    assert_equal true, @r.closed
  end

  test "winner returns nil if no donations" do
    round = Round.create
    assert_nil round.winner
  end

  test "winner returns donation with highest amount if round finished" do
    round = Round.create

    donations = []
    Rails.application.config.min_donations.times do |i|
      donations.append Donation.create(round: round, amount: i, email: 'test@example.com')
    end

    assert_nil round.winner

    round.closed = true
    round.save

    assert_equal donations.last, round.winner
  end

  test "round failed if closed without enough donations" do
    @round = Round.create(expire_time: Time.now - 1.hour)

    assert_equal true, @round.failed

    donations = []
    Rails.application.config.min_donations.times do |i|
      donations.append Donation.create(round: @round, amount: i, email: 'test@example.com')
    end

    assert_equal false, @round.failed
  end

  test "total_raised returns total donation amount after round closes successfully" do
    @round = Round.create

    assert_equal 0, @round.total_raised

    donations = []
    Rails.application.config.min_donations.times do |i|
      donations.append Donation.create(round: @round, amount: i, email: 'test@example.com')
    end

    assert_equal 0, @round.total_raised

    @round.closed = true

    assert_equal donations.inject(0) {|sum, d| sum + d.amount}, @round.total_raised
  end

  test "winner returns nil if round failed with not enough donations" do
    @round = Round.create
    @donation = Donation.create(round: @round, email: 'test@example.com')

    @round.closed = true
    @round.save
    @round.reload

    assert_equal nil, @round.winner
  end

  test "notify subscribers triggers pusher event" do
    @round = Round.create

    pusherMock = mock('Pusher')
    pusherMock.expects(:trigger).with(@round.url, 'new:charge', {})

    Round.any_instance.stubs(:realtime).returns(pusherMock)

    @round.notify_subscribers
  end
end
