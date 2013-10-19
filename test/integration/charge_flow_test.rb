require 'test_helper'

class ChargeFlowTest < ActionDispatch::IntegrationTest
  setup do
    @charity = Charity.new
    @round = Round.create(charity: @charity)

    Round.any_instance.stubs(:notify_subscribers)
  end

  test "charge and status don't show payment form after payment" do
    get '/api/rounds/' + @round.url, format: :json
    @response_json = JSON.parse(@response.body)
    assert_match '<form', @response_json['payment_info_template']

    token = 'test_stripe_token'

    post "/api/donations", {donation: {stripe_token: token, round_id: @round.id, name: 'Test User', email: 'test.email@example.com'}}
    assert_response :ok

    get '/api/rounds/' + @round.url, format: :json
    @response_json = JSON.parse(@response.body)
    assert_no_match /<form/, @response_json['payment_info_template']

    get '/round/' + @round.url
    assert_no_match /<form/, @response.body
  end
end
