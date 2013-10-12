require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  def setup
    @charities = Charity.limit(5)

    get :index
  end

  test "should get index" do
    assert_response :success
  end

  test "index selects 5 charities" do
    assert assigns(:charities).map(&:class).all? {|c| c == Charity}
    assert_equal 5, assigns(:charities).count
  end

  test "index renders charities partial" do
    assert_template 'home/_charities'
  end

  test "index displays charities" do
    @charities.each do |charity|
      assert_match "value=\"#{charity.id}\"", @response.body
      assert_match CGI::escapeHTML(charity.name), @response.body
      assert_match charity.image_name, @response.body
    end
  end
end
