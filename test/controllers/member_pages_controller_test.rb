require 'test_helper'

class MemberPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get page1" do
    get member_pages_page1_url
    assert_response :success
  end

  test "should get page2" do
    get member_pages_page2_url
    assert_response :success
  end

  test "should get page3" do
    get member_pages_page3_url
    assert_response :success
  end

end
