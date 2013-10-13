require 'test_helper'

class RoundFlowTest < ActionDispatch::IntegrationTest
  setup do
    @token = 'test_stripe_token'
    stripeMock = mock('Charge')
    stripeMock.expects(:create).with(amount: 100, currency: 'usd', card: @token, description: 'test.email@example.com').times(Rails.application.config.min_donations)

    Donation.any_instance.stubs(:chargeObject).returns(stripeMock)
    Donation.any_instance.stubs(:amount).returns(1)

    Round.any_instance.stubs(:notify_subscribers)
  end

  test "can determine if user is winner in Round#display" do
    @charity = Charity.create
    @round = Round.create(charity: @charity)

    users = (1..Rails.application.config.min_donations).collect { open_session }
    donations = []

    users.each do |user|
      user.post "/api/donations", round_id: @round.url, email: 'test.email@example.com', name: 'Test User', stripe_token: @token
      donations.push user.assigns(:donation)
    end

    @round.closed = true
    @round.save

    users.each_with_index do |user, i|
      user.get '/round/'+@round.url
      if @round.winner == donations[i]
        assert_equal true, user.assigns(:winner)
      else
        assert_equal false, user.assigns(:winner)
      end
    end
  end
end
