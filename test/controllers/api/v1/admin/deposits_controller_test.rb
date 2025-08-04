require "test_helper"

class Api::V1::Admin::DepositsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_admin_deposits_index_url
    assert_response :success
  end

  test "should get show" do
    get api_v1_admin_deposits_show_url
    assert_response :success
  end
end
