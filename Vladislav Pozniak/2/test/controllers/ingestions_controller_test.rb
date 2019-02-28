require 'test_helper'

class IngestionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ingestion = ingestions(:one)
  end

  test "should get index" do
    get ingestions_url
    assert_response :success
  end

  test "should get new" do
    get new_ingestion_url
    assert_response :success
  end

  test "should create ingestion" do
    assert_difference('Ingestion.count') do
      post ingestions_url, params: { ingestion: { dish: @ingestion.dish, time: @ingestion.time, user_id: @ingestion.user_id } }
    end

    assert_redirected_to ingestion_url(Ingestion.last)
  end

  test "should show ingestion" do
    get ingestion_url(@ingestion)
    assert_response :success
  end

  test "should get edit" do
    get edit_ingestion_url(@ingestion)
    assert_response :success
  end

  test "should update ingestion" do
    patch ingestion_url(@ingestion), params: { ingestion: { dish: @ingestion.dish, time: @ingestion.time, user_id: @ingestion.user_id } }
    assert_redirected_to ingestion_url(@ingestion)
  end

  test "should destroy ingestion" do
    assert_difference('Ingestion.count', -1) do
      delete ingestion_url(@ingestion)
    end

    assert_redirected_to ingestions_url
  end
end
