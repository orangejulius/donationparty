require 'test_helper'

class RoundsControllerTest < ActionController::TestCase
  setup do
    @round = Round.new
  end

  test "new round should be displayable" do
    @charity = Charity.create(name: 'Test Charity')
    post :set_charity, url: @round.url,  charity: @charity.id
    assert_response :success

    get :display, url: @round.url
    assert_response :success
  end

  test "closed round displayed with closed view" do
    @round.closed = true
    @round.save

    get :display, url: @round.url
    assert_response :success
    assert_template :closed
  end

  test "round status returns round and html info" do
    get :status, url: @round.url
    check_status_response
  end

  test "charge creates new donation and returns round info" do
    post :charge, stripeToken: 'token', round_id: @round.url, name: 'Test User', email: 'test.email@example.com'

    @donation = Donation.where(round_id: @round.id).first
    assert_not_nil @donation
    assert_equal 'token', @donation.stripe_token
    assert_equal 'Test User', @donation.name
    assert_equal 'test.email@example.com', @donation.email
    check_status_response
    assert_no_match /<form/, @response_json['payment_info_template']
  end

  def check_status_response
    assert_response :success

    @response_json = JSON.parse(@response.body)
    assert_equal @round.seconds_left.round, @response_json['seconds_left']
    assert_match '<li', @response_json['donations_template']
    assert_match '<h3>', @response_json['payment_info_template']
  end

  test "charity can only be set once" do
    @charity = Charity.create(name: 'Test Charity')
    @charity2 = Charity.create(name: 'Test Charity2')
    post :set_charity, url: @round.url, charity: @charity.id
    assert_equal @charity, assigns[:round].charity

    post :set_charity, url: @round.url, charity: @charity2.id
    assert_equal @charity, assigns[:round].charity
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
      post :create, round: { closed: @round.closed, expire_time: @round.expire_time, failed: @round.failed, max_amount: @round.max_amount, secret_token: @round.secret_token, url: @round.url, winning_address1: @round.winning_address1, winning_address2: @round.winning_address2 }
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
    put :update, id: @round, round: { closed: @round.closed, expire_time: @round.expire_time, failed: @round.failed, max_amount: @round.max_amount, secret_token: @round.secret_token, url: @round.url, winning_address1: @round.winning_address1, winning_address2: @round.winning_address2 }
    assert_redirected_to round_path(assigns(:round))
  end

  test "should destroy round" do
    assert_difference('Round.count', -1) do
      delete :destroy, id: @round
    end

    assert_redirected_to rounds_path
  end
end
