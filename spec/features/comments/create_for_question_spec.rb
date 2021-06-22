require 'rails_helper'

feature 'User can create comment', %q{
  In order to get correct answer from
  a community As an authenticated user
  I'd like to be able to comment the question
  or qnswer
} do

  given(:user) {create(:user)}
  given!(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
      click_link('Add comment')
    end

    scenario 'show/hide form for create a comment', js: true do
      expect(page).to have_content 'Hide comment'
      within "#comments-form-question_#{question.id}" do
        expect(page).to have_content 'Body'
      end
      within ".question-comments" do
        expect(page).to have_selector(:link_or_button, 'Create')
      end
    end

    scenario 'add a comment', js: true do
      fill_in 'comment[body]', with: 'Test comment'
      within ".question-comments" do
        click_on 'Create'
      end
      expect(page).to have_content "Test comment"
    end
  end

  describe 'Unauthenticated user ' do
    scenario 'tries to add a comment' do
      visit question_path(question)
      expect(page).to_not have_selector(:link_or_button, 'Add comment')
    end
  end
end
