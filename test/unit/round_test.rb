require 'test_helper'

class RoundTest < ActiveSupport::TestCase
  test "newly created round has randomly generated url string" do
    r = Round.new
    assert_not_nil r.url
    assert_match /^[[:xdigit:]]{6}$/, r.url

    r2 = Round.new
    assert_not_equal r.url, r2.url
  end

  test "newly created round has expire time of one hour" do
    r = Round.new
    assert_not_nil r.expire_time
    assert Time.now + 1.hours - r.expire_time < 1 # fuzzy time comparison
  end

  test "url and expire_time persist on save" do
    r = Round.create
    url = r.url

    r2 = Round.where(url: url).first

    assert_equal r2.url, r.url
    assert_equal r2.expire_time, r.expire_time
  end

  test "seconds_left returns time until round expires" do
    r = Round.new

    now = Time.now
    round_duration = Rails.application.config.round_duration
    r.expire_time = now + round_duration

    assert r.seconds_left - round_duration < 1
  end

  test "seconds_left is never negative" do
    r = Round.new

    now = Time.now
    r.expire_time = now - 2.hours
    assert_equal 0, r.seconds_left
  end

  test "expired rounds automatically marked closed" do
    @r = Round.new
    @r.expire_time = Time.now - Rails.application.config.round_duration - 1.hours

    assert_equal true, @r.closed
  end

  test "winner returns nil if no donations" do
    round = Round.new
    assert_nil round.winner
  end

  test "winner returns donation with highest amount if round finished" do
    round = Round.create

    d1 = Donation.create(round: round, amount: 4, email: 'test@example.com')
    d2 = Donation.create(round: round, amount: 5, email: 'test@example.com')
    d3 = Donation.create(round: round, amount: 3, email: 'test@example.com')

    assert_nil round.winner

    round.closed = true
    round.save

    assert_equal d2, round.winner
  end

  test "charity info accessible through round" do
    @round = Round.new
    @charity = Charity.new(name: 'Test Charity', image_name: 'test.png')

    @round.charity = @charity

    @round.save
    @round.reload

    assert_equal @charity.name, @round.charity.name
  end

  test "round failed if closed without enough donations" do
    @round = Round.create(expire_time: Time.now - 1.hour)

    assert_equal true, @round.failed

    @d1 = Donation.create(round: @round, amount: 5, email: 'test@example.com')
    @d2 = Donation.create(round: @round, amount: 2, email: 'test@example.com')
    @d3 = Donation.create(round: @round, amount: 9, email: 'test@example.com')

    assert_equal false, @round.failed
  end

  test "total_raised returns total donation amount after round closes successfully" do
    @round = Round.create

    assert_equal 0, @round.total_raised

    @d1 = Donation.create(round: @round, amount: 5, email: 'test@example.com')
    @d2 = Donation.create(round: @round, amount: 2, email: 'test@example.com')
    @d3 = Donation.create(round: @round, amount: 9, email: 'test@example.com')

    assert_equal 0, @round.total_raised

    @round.closed = true

    assert_equal 16, @round.total_raised
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
    pusherMock.expects(:trigger).with(@round.url, 'new:charge')

    Round.any_instance.stubs(:realtime).returns(pusherMock)

    @round.notify_subscribers
  end
end
