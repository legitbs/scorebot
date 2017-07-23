require 'test_helper'

class ReplacementsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get replacements_index_url
    assert_response :success
  end

  test "should get show" do
    get replacements_show_url
    assert_response :success
  end

  test "should get new" do
    get replacements_new_url
    assert_response :success
  end

end
