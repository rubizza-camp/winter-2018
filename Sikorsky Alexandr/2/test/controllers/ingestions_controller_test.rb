require 'test_helper'

class IngestionsControllerTest < ActionDispatch::IntegrationTest
  test 'should get show' do
    get ingestions_show_url
    assert_response :success
  end

  test 'should get new' do
    get ingestions_new_url
    assert_response :success
  end

  test 'should get edit' do
    get ingestions_edit_url
    assert_response :success
  end

  test 'should get create' do
    get ingestions_create_url
    assert_response :success
  end

  test 'should get update' do
    get ingestions_update_url
    assert_response :success
  end

  test 'should get destroy' do
    get ingestions_destroy_url
    assert_response :success
  end
end
