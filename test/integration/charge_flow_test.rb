require 'test_helper'

class ChargeFlowTest < ActionDispatch::IntegrationTest
  setup do
    @charity = Charity.new
    @round = Round.create(charity: @charity)
  end

  test "charge and status don't show payment form after payment" do
    get '/round_status/' + @round.url
    @response_json = JSON.parse(@response.body)
    assert_match '<form', @response_json['payment_info_template']

    token = Stripe::Token.create(
      :card => {
      :number => "4242424242424242",
      :exp_month => 2,
      :exp_year => 2014,
      :cvc => 314
    },)

    post '/charge', stripeToken: token.id, round_id: @round.url, name: 'Test User', email: 'test.email@example.com'
    @response_json = JSON.parse(@response.body)
    assert_no_match /<form/, @response_json['payment_info_template']

    get '/round_status/' + @round.url
    @response_json = JSON.parse(@response.body)
    assert_no_match /<form/, @response_json['payment_info_template']

    get '/round/' + @round.url
    assert_no_match /<form/, @response.body
  end
end
