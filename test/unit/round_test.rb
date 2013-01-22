require 'test_helper'

class RoundTest < ActiveSupport::TestCase
  test "newly created round has randomly generated url string" do
    r = Round.new
    assert_not_nil r.url
    assert_match /[[:xdigit:]]/, r.url

    r2 = Round.new
    assert_not_equal r.url, r2.url
  end
end
