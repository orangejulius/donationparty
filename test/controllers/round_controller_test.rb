require 'test_helper'

class RoundControllerTest < ActionController::TestCase
  setup do
    @charity = Charity.first
    @round = Round.create
  end

  test "create creates new round" do
    post :create, charity: @charity
    assert_redirected_to round_path(assigns(:round))
  end

  test "create redirects back home if no charity passed" do
    post :create
    assert_redirected_to :root
  end

  test "show shows round" do
    @round.charity = Charity.create
    @round.save

    get :show, id: @round
    assert_response :success
  end

  test "show uses closed view when round closed" do
    @round.closed = true
    @round.charity = Charity.create
    @round.save

    get :show, id: @round
    assert_response :success
    assert_template :closed
  end

  test "updating shipping request requires correct round url and donation token" do
    @charity = Charity.create
    @round = Round.create(charity: @charity)

    Rails.application.config.min_donations.times do
      Donation.create(round: @round, email: 'test@example.com')
    end

    @round.closed = true
    @round.save

    post :update_address
    assert_response 403

    post :update_address, url: @round.url
    assert_response 403

    post :update_address, token: @round.winner.token
    assert_response 403

    post :update_address, url: @round.url, token: 'invalid token'
    assert_response 403

    post :update_address, url: @round.url, token: @round.winner.token, address1: '123 a street', address2: 'Apt 23',
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
