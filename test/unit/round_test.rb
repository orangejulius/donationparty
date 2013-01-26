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
end
