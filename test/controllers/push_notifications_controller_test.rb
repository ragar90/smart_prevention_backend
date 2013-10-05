require 'test_helper'

class PushNotificationsControllerTest < ActionController::TestCase
  test "should get alert_disaster" do
    get :alert_disaster
    assert_response :success
  end

  test "should get disaster_finish" do
    get :disaster_finish
    assert_response :success
  end

  test "should get normality_restored" do
    get :normality_restored
    assert_response :success
  end

  test "should get broadcast_alert" do
    get :broadcast_alert
    assert_response :success
  end

end
