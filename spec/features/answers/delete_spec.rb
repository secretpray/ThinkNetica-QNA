require 'rails_helper'
require 'capybara/apparition'

feature 'User can delete his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like ot be able to delete my question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:answer_with_link) { create :answer, :with_link, question: question, user: user }


  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Delete'
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'delete his answer' do
      # Capybara.current_driver = :selenium_chrome
      # :selenium, :selenium_headless, :selenium_chrome, :selenium_chrome_headless, :apparition
      within '.list-answers' do
        accept_confirm do
          click_on('Delete', match: :first)
        end
      end
      sleep 1
      accept_confirm do
        find("#button-delete-answer-#{Answer.last.id}").click
      end
      # Capybara.use_default_driver
    end

    scenario "delete his link", js: true do
      within '#answer_list' do
        click_on "Delete Link"
        expect(page).to_not have_content "Google"
      end
    end

    scenario 'delete his attachment', js: true do
      fill_in 'answer_body', with: 'Own answer'
      attach_file 'answer_files', ["#{Rails.root}/spec/rails_helper.rb"]

      click_on('Create')

      within '#answer_list' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_content 'Remove'
      end
      accept_confirm { page.click_link("Remove") }

      expect(page).to_not have_link 'rails_helper.rb'
      expect(page).to_not have_content 'Remove'
    end

    scenario "tries to delete other user's answer" do

      answer.user_id += 1
      visit question_path(question)

      expect(page).to_not have_content 'nDelete'
      expect(page).to have_content answer.body
      expect(page).to have_content 'Google'
    end
  end
end
