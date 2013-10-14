require 'test_helper'

class Api::AddressesControllerTest < ActionController::TestCase
  setup do
    @charity = Charity.create
    @round = Round.create(charity: @charity)

    Rails.application.config.min_donations.times do
      Donation.create(round: @round, email: 'test@example.com')
    end

    @round.update_attribute(:closed, true)
  end

  test "create with no params returns 403" do
    post :create
    assert_response 403
  end

  test "create with only valid url returns 403" do
    post :create, url: @round.url
    assert_response 403
  end

  test "create with only valid token returns 403" do
    post :create, token: @round.winner.token
    assert_response 403
  end

  test "create with invalid token returns 403" do
    post :create, url: @round.url, token: 'invalid token'
    assert_response 403
  end

  test "updating shipping request requires correct round url and donation token" do
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
