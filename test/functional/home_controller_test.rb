require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  def setup
    @charities = []
    @charities << Charity.create(name: 'Test Charity 1', image_name: 'test1.png')
    @charities << Charity.create(name: 'Test Charity 2', image_name: 'test2.png')

    get :index
  end

  test "should get index" do
    assert_response :success
  end

  test "index displays charities" do
    @charities.each do |charity|
      assert_match 'value="%s"' % charity.id, @response.body
      assert_match charity.name, @response.body
      assert_match charity.image_name, @response.body
    end
  end
end
