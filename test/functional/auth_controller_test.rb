require 'test_helper'

class AuthControllerTest < ActionController::TestCase
  test "should get facebook_authenticate" do
    get :facebook_authenticate
    assert_response :success
  end

  test "should get facebook_callback" do
    get :facebook_callback
    assert_response :success
  end

end
