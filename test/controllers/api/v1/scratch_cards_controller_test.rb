require "test_helper"

class Api::V1::ScratchCardsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_scratch_cards_index_url
    assert_response :success
  end
end
