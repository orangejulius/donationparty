require 'test_helper'

class Api::AddressesControllerTest < ActionController::TestCase
  test "updating shipping request requires correct round url and donation token" do
    @charity = Charity.create
    @round = Round.create(charity: @charity)

    Rails.application.config.min_donations.times do
      Donation.create(round: @round, email: 'test@example.com')
    end

    @round.closed = true
    @round.save

    post :create
    assert_response 403

    post :create, url: @round.url
    assert_response 403

    post :create, token: @round.winner.token
    assert_response 403

    post :create, url: @round.url, token: 'invalid token'
    assert_response 403

    post :create, url: @round.url, token: @round.winner.token, address1: '123 a street', address2: 'Apt 23',
      zip_code: '94105', city: 'San Francisco', state: 'CA', country: 'USA'
    assert_redirected_to round_path(@round)
    @round.reload
    assert_equal '123 a street', @round.address.line1
    assert_equal 'Apt 23', @round.address.line2
    assert_equal '94105', @round.address.zip_code
    assert_equal 'San Francisco', @round.address.city
    assert_equal 'CA', @round.address.state
    assert_equal 'USA', @round.address.country
  end
end
