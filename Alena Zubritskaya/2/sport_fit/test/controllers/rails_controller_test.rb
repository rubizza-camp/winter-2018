require 'test_helper'

class RailsControllerTest < ActionDispatch::IntegrationTest
  test "should get generate" do
    get rails_generate_url
    assert_response :success
  end

  test "should get controller" do
    get rails_controller_url
    assert_response :success
  end

  test "should get StaticPages" do
    get rails_StaticPages_url
    assert_response :success
  end

  test "should get home" do
    get rails_home_url
    assert_response :success
  end

  test "should get help" do
    get rails_help_url
    assert_response :success
  end

end
