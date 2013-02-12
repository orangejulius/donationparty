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

    token = 'test_stripe_token'

    stripeMock = mock('Charge')
    stripeMock.expects(:create).with(amount: 100, currency: 'usd', card: token, description: 'test.email@example.com')

    Donation.any_instance.stubs(:chargeObject).returns(stripeMock)
    Donation.any_instance.stubs(:amount).returns(1)

    post '/charge', stripeToken: token, round_id: @round.url, name: 'Test User', email: 'test.email@example.com'
    @response_json = JSON.parse(@response.body)
    assert_no_match /<form/, @response_json['payment_info_template']

    get '/round_status/' + @round.url
    @response_json = JSON.parse(@response.body)
    assert_no_match /<form/, @response_json['payment_info_template']

    get '/round/' + @round.url
    assert_no_match /<form/, @response.body
  end
end
