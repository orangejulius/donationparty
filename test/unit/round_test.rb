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
    r = Round.new
    url = r.url
    r.save

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
    d1 = Donation.new
    d1.round = round
    d1.amount = 4
    d1.save

    d2 = Donation.new
    d2.round = round
    d2.amount = 5
    d2.save

    assert_nil round.winner

    round.closed = true
    round.save

    assert_equal d2, round.winner
  end
end
