require 'test_helper'

class Api::DonationsControllerTest < ActionController::TestCase
  test "create creates new donation" do
    @round = Round.create(charity: Charity.first)
    token = 'test_stripe_token'

    stripeMock = mock('Charge')
    stripeMock.expects(:create).with(amount: 100, currency: 'usd', card: token, description: 'test.email@example.com')

    Donation.any_instance.stubs(:chargeObject).returns(stripeMock)
    Donation.any_instance.stubs(:amount).returns(1)

    Round.any_instance.stubs(:notify_subscribers)
    Round.any_instance.expects(:notify_subscribers).once

    post :create, stripe_token: token, round_id: @round.url, name: 'Test User', email: 'test.email@example.com'
    assert_response :success

    @donation = Donation.find_by round: @round
    assert_not_nil @donation
    assert_equal token, @donation.stripe_token
    assert_equal 'Test User', @donation.name
    assert_equal 'test.email@example.com', @donation.email
    assert_equal @donation.token, cookies['donated_'+@round.url]
  end
end
