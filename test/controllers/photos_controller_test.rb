require 'test_helper'

class PhotosControllerTest < ActionDispatch::IntegrationTest
  test "should get upload" do
    get photos_upload_url
    assert_response :success
  end

  test "should get show" do
    get photos_show_url
    assert_response :success
  end

end
