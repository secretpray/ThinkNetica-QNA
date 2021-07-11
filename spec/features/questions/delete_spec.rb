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

      expect(page).to_not have_content question.title
    end

    scenario 'delete the attached file from their question' do
      visit root_path
      click_link 'Edit'
      attach_file 'question_files', ["#{Rails.root}/spec/rails_helper.rb"]
      click_on 'Update'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_content 'No answers!'

      accept_confirm do
        page.click_link("Remove")
      end

      expect(page).to_not have_link 'rails_helper.rb'
      expect(page).to have_content 'No answers!'
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
