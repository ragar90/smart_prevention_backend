require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get alerts" do
    get :alerts
    assert_response :success
  end

  test "should get refuges" do
    get :refuges
    assert_response :success
  end

  test "should get rescues" do
    get :rescues
    assert_response :success
  end

  test "should get notifications" do
    get :notifications
    assert_response :success
  end

end
