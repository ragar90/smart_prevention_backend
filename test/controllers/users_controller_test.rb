require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get ping" do
    get :ping
    assert_response :success
  end

  test "should get report_status" do
    get :report_status
    assert_response :success
  end

end
