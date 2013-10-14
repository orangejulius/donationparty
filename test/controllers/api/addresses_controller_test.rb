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
    @address = Address.new(line1: '123 a street',
                           line2: 'Apt 23',
                           zip_code: '94105',
                           city: 'San Francisco',
                           state: 'CA',
                           country: 'USA',
                           round_id: @round.id )

    post :create, {address: @address.attributes, round_token: @round.winner.token}
    assert_redirected_to round_path(@round)

    assert @address.identical? assigns(:address)
  end
end
