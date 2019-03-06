require 'test_helper'

class IngestionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get ingestions_index_url
    assert_response :success
  end

end
