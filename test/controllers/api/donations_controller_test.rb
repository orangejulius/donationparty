require 'test_helper'

class Api::DonationsControllerTest < ActionController::TestCase
  test "create creates new donation" do
    @round = Round.create(charity: Charity.first)
    @donation = Donation.new(email: 'test.email@example.com', name: 'Test User', stripe_token: 'test_stripe_token', round: @round)

    stripeMock = mock('Charge')
    stripeMock.expects(:create).with(amount: 100, currency: 'usd', card: @donation.stripe_token, description: @donation.email)

    Donation.any_instance.stubs(:chargeObject).returns(stripeMock)
    Donation.any_instance.stubs(:amount).returns(1)

    Round.any_instance.expects(:notify_subscribers).once

    post :create, {donation: @donation.attributes}
    assert_response :success

    @new_donation = Donation.find_by round: @round
    assert_equal @donation.stripe_token, @new_donation.stripe_token
    assert_equal @donation.name, @new_donation.name
    assert_equal @donation.email, @new_donation.email
    assert_equal @new_donation.token, cookies['donated_'+@round.url]
  end
end
