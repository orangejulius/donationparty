require 'test_helper'

class RoundMailerTest < ActionMailer::TestCase
  test "round_success" do
    mail = RoundMailer.round_success
    assert_equal "Round success", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
