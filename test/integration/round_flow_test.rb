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
    @charity = Charity.first
    @round = Round.create(charity: @charity)

    users = Rails.application.config.min_donations.times.map { open_session }

    donations = users.map do |user|
      user.post "/api/donations", {donation: {round_id: @round.id, email: 'test.email@example.com', name: 'Test User', stripe_token: @token}}
      user.assigns(:donation)
    end

    @round.update_attribute(:closed, true)

    users.each_with_index do |user, i|
      user.get '/round/'+@round.url
      assert_equal @round.winner == donations[i], user.assigns(:winner)
    end
  end
end
