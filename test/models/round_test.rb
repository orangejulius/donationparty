require 'test_helper'

class RoundTest < ActiveSupport::TestCase
  def setup
    @round = Round.new
  end

  test "newly created round has randomly generated url string" do
    stub_secure_random_hex(Round::URL_LENGTH / 2)
    round = Round.new

    assert_equal fake_random_hex(Round::URL_LENGTH), round.url
  end

  test "newly created round has expire time of one hour" do
    assert_not_nil @round.expire_time
    assert Time.now + 1.hours - @round.expire_time < 1 # fuzzy time comparison
  end

  test "url and expire_time persist on save" do
    @round.save
    round = Round.find_by url: @round.url

    assert_equal @round.url, round.url

    assert_equal @round.expire_time, round.expire_time
  end

  test "expire_time does not have miliseconds" do
    assert @round.expire_time.change(usec: 0) == @round.expire_time, "round.expire_time has milisecond precision"
  end

  test "seconds_left returns time until round expires" do
    round_duration = Rails.application.config.round_duration
    @round.expire_time = Time.now + round_duration

    assert @round.seconds_left - round_duration < 1
  end

  test "seconds_left is never negative" do
    @round.expire_time = Time.now - 2.hours
    assert_equal 0, @round.seconds_left
  end

  test "seconds_left has second precision" do
    assert_equal @round.seconds_left.round, @round.seconds_left
  end

  test "expired rounds automatically marked closed" do
    @round.expire_time = Time.now - Rails.application.config.round_duration - 1.hours

    assert_equal true, @round.closed
  end

  test "winner returns nil if no donations" do
    assert_nil @round.winner
  end

  test "winner returns donation with highest amount if round finished" do
    @round.save

    Rails.application.config.min_donations.times do
      Donation.create(round: @round, email: 'test@example.com')
    end

    assert_nil @round.winner

    @round.update_attribute(:closed, true)

    assert_equal @round.donations.max_by(&:amount), @round.winner
  end

  test "round failed if closed without enough donations" do
    @round.expire_time = Time.now - 1.hour
    @round.save

    assert_equal true, @round.failed?

    Rails.application.config.min_donations.times do
      Donation.create(round: @round, email: 'test@example.com')
    end

    assert_equal false, @round.failed?
  end

  test "total_raised returns total donation amount after round closes successfully" do
    @round.save
    assert_equal 0, @round.total_raised

    Rails.application.config.min_donations.times do
      Donation.create(round: @round, email: 'test@example.com')
    end

    assert_equal 0, @round.total_raised

    @round.closed = true

    assert_equal @round.donations.map(&:amount).inject(&:+), @round.total_raised
  end

  test "winner returns nil if round failed with not enough donations" do
    @round.save
    @donation = Donation.create(round: @round, email: 'test@example.com')

    @round.update_attribute(:closed, true)
    @round.reload

    assert_equal nil, @round.winner
  end

  test "notify subscribers triggers pusher event" do
    pusherMock = mock('Pusher')
    pusherMock.expects(:trigger).with(@round.url, 'new:charge', {})

    Round.any_instance.stubs(:realtime).returns(pusherMock)

    @round.notify_subscribers
  end
end
