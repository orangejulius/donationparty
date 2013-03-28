require 'test_helper'

class DonationsControllerTest < ActionController::TestCase
  setup do
    @round = Round.create
    @token = 'test_stripe_token'

    stripeMock = mock('Charge')
    stripeMock.expects(:create).with(amount: 100, currency: 'usd', card: @token, description: 'test.email@example.com')

    Donation.any_instance.stubs(:chargeObject).returns(stripeMock)
    Donation.any_instance.stubs(:amount).returns(1)

    Round.any_instance.stubs(:notify_subscribers)
    Round.any_instance.expects(:notify_subscribers).once

    post :create, stripeToken: @token, round_id: @round.url, name: 'Test User', email: 'test.email@example.com'
    @donation = Donation.where(round_id: @round.id).first
  end

  test "create creates new donation and returns round info" do
    assert_not_nil @donation
    assert_equal @token, @donation.stripe_token
    assert_equal 'Test User', @donation.name
    assert_equal 'test.email@example.com', @donation.email
  end
end
