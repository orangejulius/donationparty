require 'test_helper'

class Api::RoundsControllerTest < ActionController::TestCase
  setup do
    @charity = Charity.first
    @round = Round.create

  end
  test 'round show contains round info' do
    get :show, id: @round.url, format: :json
    assert_response :ok

    json = JSON.parse(response.body)

    assert_equal @round.expire_time.as_json, json['round']['expire_time']
    assert_equal @round.closed, json['round']['closed']
  end
end
