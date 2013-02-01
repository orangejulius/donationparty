require 'test_helper'

class RoundCreationTest < ActionDispatch::IntegrationTest
  test "rounds are viewable after creation" do
    get '/'
    assert_response :success

    post '/round/' + assigns[:round].url, charity: 'test_charity'
    assert_response :success
  end
end
