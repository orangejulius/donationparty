require 'test_helper'

class RoundControllerTest < ActionController::TestCase
  setup do
    @charity = Charity.first
    @round = Round.create
  end

  test "create creates new round" do
    post :create, charity: @charity
    assert_redirected_to round_path(assigns(:round))
  end

  test "create redirects back home if no charity passed" do
    post :create
    assert_redirected_to :root
  end

  test "show shows round" do
    @round.charity = Charity.create
    @round.save

    get :show, id: @round
    assert_response :success
  end

  test "show uses closed view when round closed" do
    @round.closed = true
    @round.charity = Charity.create
    @round.save

    get :show, id: @round
    assert_response :success
    assert_template :closed
  end
end
