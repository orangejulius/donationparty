require 'test_helper'

class RoundCreationTest < ActionDispatch::IntegrationTest
  test "rounds are viewable after creation" do
    @charity = Charity.create(name: 'Test Charity')
    get '/'
    assert_response :success

    post '/round/' + assigns[:round].url, charity: @charity.id
    assert_response :success

    assert_equal @charity, assigns[:round].charity

    get '/round/' + assigns[:round].url
    assert_response :success
  end
end
