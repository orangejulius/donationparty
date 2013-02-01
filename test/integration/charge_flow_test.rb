require 'test_helper'

class ChargeFlowTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  setup do
    @round = rounds(:one)
  end

  test "charge and status don't show payment form after payment" do
    get '/round_status/' + @round.url
    @response_json = JSON.parse(@response.body)
    assert_match '<form', @response_json['payment_info_template']

    post '/charge', stripeToken: 'token', round_id: @round.url, name: 'Test User', email: 'test.email@example.com'
    @response_json = JSON.parse(@response.body)
    assert_no_match /<form/, @response_json['payment_info_template']

    get '/round_status/' + @round.url
    @response_json = JSON.parse(@response.body)
    assert_no_match /<form/, @response_json['payment_info_template']

    get '/round/' + @round.url
    assert_no_match /<form/, @response.body
  end
end
