require 'test_helper'

class RoundFlowTest < ActionDispatch::IntegrationTest
  test "can determine if user is winner in Round#display" do
    @charity = Charity.create
    @round = Round.create(charity: @charity)

    users = (1..3).collect { open_session }
    donations = []

    users.each do |user|
      token = Stripe::Token.create(
        :card => {
        :number => "4242424242424242",
        :exp_month => 2,
        :exp_year => 2014,
        :cvc => 314
      },)
      user.post '/charge', round_id: @round.url, email: 'test@example.com', name: 'Test User', stripeToken: token.id
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
