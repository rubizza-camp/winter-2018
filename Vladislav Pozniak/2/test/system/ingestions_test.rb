# frozen_string_literal: true

require 'application_system_test_case'

class IngestionsTest < ApplicationSystemTestCase
  setup do
    @ingestion = ingestions(:one)
  end

  test 'visiting the index' do
    visit ingestions_url
    assert_selector 'h1', text: 'Ingestions'
  end

  test 'creating a Ingestion' do
    visit ingestions_url
    click_on 'New Ingestion'

    fill_in 'Dish', with: @ingestion.dish
    fill_in 'Time', with: @ingestion.time
    fill_in 'User', with: @ingestion.user_id
    click_on 'Create Ingestion'

    assert_text 'Ingestion was successfully created'
    click_on 'Back'
  end

  test 'updating a Ingestion' do
    visit ingestions_url
    click_on 'Edit', match: :first

    fill_in 'Dish', with: @ingestion.dish
    fill_in 'Time', with: @ingestion.time
    fill_in 'User', with: @ingestion.user_id
    click_on 'Update Ingestion'

    assert_text 'Ingestion was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Ingestion' do
    visit ingestions_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Ingestion was successfully destroyed'
  end
end
