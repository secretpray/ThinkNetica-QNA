require 'rails_helper'
require 'capybara/apparition'

feature 'User can delete his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like ot be able to delete my question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthenticated can not edit answer' do
    visit root_path

    expect(page).to_not have_link 'Delete'
  end

  describe 'Authenticated user', js: true do
    background { sign_in(user) }

    before(:all) do
      Capybara.javascript_driver = :apparition # Add JS support without other driver!!!
    end

    scenario 'delete his question' do

      visit root_path
      expect(page).to have_content 'Delete'
      accept_confirm do
        page.click_link("Delete")
      end
      
      ####### JS testig (other variant) ##############
      # page.driver.browser.switch_to.alert.accept
      # dialog.text.should = "Are you sure?"
      # dialog.accept
      # or
      # dialog.dismiss

      expect(page).to_not have_content question.title
    end

    after(:all) do
      Capybara.use_default_driver
    end

    scenario "tries to delete other user's question" do
      question.user_id += 1
      click_on('Home')
      expect(page).to_not have_content 'nDelete'
      expect(page).to have_content question.title
    end
  end
end
