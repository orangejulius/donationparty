require 'test_helper'

class RoundsControllerTest < ActionController::TestCase
  setup do
    @round = rounds(:one)
  end

  test "new round should be displayable" do
    @r = Round.new
    post :display, url: @r.url,  charity: 'eff'
    assert_response :success
  end

  test "round status returns round and html info" do
    get :status, url: @round.url
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rounds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create round" do
    assert_difference('Round.count') do
      post :create, round: { charity: @round.charity, closed: @round.closed, expire_time: @round.expire_time, failed: @round.failed, max_amount: @round.max_amount, secret_token: @round.secret_token, url: @round.url, winning_address1: @round.winning_address1, winning_address2: @round.winning_address2 }
    end

    assert_redirected_to round_path(assigns(:round))
  end

  test "should show round" do
    get :show, id: @round
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @round
    assert_response :success
  end

  test "should update round" do
    put :update, id: @round, round: { charity: @round.charity, closed: @round.closed, expire_time: @round.expire_time, failed: @round.failed, max_amount: @round.max_amount, secret_token: @round.secret_token, url: @round.url, winning_address1: @round.winning_address1, winning_address2: @round.winning_address2 }
    assert_redirected_to round_path(assigns(:round))
  end

  test "should destroy round" do
    assert_difference('Round.count', -1) do
      delete :destroy, id: @round
    end

    assert_redirected_to rounds_path
  end
end
