require 'test_helper'

class ListsControllerTest < ActionDispatch::IntegrationTest
  test "should get of_currencies" do
    get lists_of_currencies_url
    assert_response :success
  end

  test "should get of_pairs" do
    get lists_of_pairs_url
    assert_response :success
  end

  test "should get of_trios" do
    get lists_of_trios_url
    assert_response :success
  end

end
