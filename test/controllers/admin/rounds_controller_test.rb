require 'test_helper'

class Admin::RoundsControllerTest < ActionController::TestCase
  setup do
    @round = Round.create
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
      post :create, round: { closed: @round.closed, expire_time: @round.expire_time, max_amount: @round.max_amount, secret_token: @round.secret_token, url: @round.url }
    end

    assert_redirected_to admin_round_url(assigns(:round))
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
    put :update, id: @round, round: { closed: @round.closed, expire_time: @round.expire_time, max_amount: @round.max_amount, secret_token: @round.secret_token, url: @round.url }
    assert_redirected_to admin_round_path(assigns(:round))
  end

  test "should destroy round" do
    assert_difference('Round.count', -1) do
      delete :destroy, id: @round
    end

    assert_redirected_to admin_rounds_path
  end
end
