require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "index displays charities" do
    @charity1 = Charity.create(name: 'Test Charity 1', image_name: 'test1.png')
    @charity2 = Charity.create(name: 'Test Charity 2', image_name: 'test2.png')

    get :index
    assert_match 'value="%s"' % @charity1.id, @response.body
    assert_match @charity1.name, @response.body
    assert_match @charity1.image_name, @response.body
    assert_match 'value="%s"' % @charity2.id, @response.body
    assert_match @charity2.name, @response.body
    assert_match @charity2.image_name, @response.body
  end
end
