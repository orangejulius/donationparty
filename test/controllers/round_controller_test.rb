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

  test "charge creates new donation and returns round info" do
    token = 'test_stripe_token'

    stripeMock = mock('Charge')
    stripeMock.expects(:create).with(amount: 100, currency: 'usd', card: token, description: 'test.email@example.com')

    Donation.any_instance.stubs(:chargeObject).returns(stripeMock)
    Donation.any_instance.stubs(:amount).returns(1)

    Round.any_instance.stubs(:notify_subscribers)
    Round.any_instance.expects(:notify_subscribers).once

    post :charge, stripe_token: token, round_id: @round.url, name: 'Test User', email: 'test.email@example.com'
    assert_response :success

    @donation = Donation.where(round_id: @round.id).first
    assert_not_nil @donation
    assert_equal token, @donation.stripe_token
    assert_equal 'Test User', @donation.name
    assert_equal 'test.email@example.com', @donation.email
    assert_equal @donation.token, cookies['donated_'+@round.url]
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
