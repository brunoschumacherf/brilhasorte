require "test_helper"

class Api::V1::Admin::WithdrawalsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_admin_withdrawals_index_url
    assert_response :success
  end

  test "should get show" do
    get api_v1_admin_withdrawals_show_url
    assert_response :success
  end
end
