require 'test_helper'

class RoundMailerTest < ActionMailer::TestCase
  test "round_success" do
    round = Round.new
    email = 'testemail@example.com'
    mail = RoundMailer.round_success(round, email)
    assert_equal "Round success", mail.subject
    assert_equal [email], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "round_failed" do
    round = Round.new
    email = 'testemail@example.com'
    mail = RoundMailer.round_failed(round, email)
    assert_equal "not enough people donated", mail.subject
  end

end
