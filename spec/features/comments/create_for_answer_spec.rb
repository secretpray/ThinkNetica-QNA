require 'rails_helper'

feature 'User can create comment', %q{
  In order to get correct answer from
  a community As an authenticated user
  I'd like to be able to comment the question
  or qnswer
} do

  given(:user) {create(:user)}
  given!(:question) { create(:question) }
  # given!(:answer) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
      fill_in 'answer[body]', with: 'Test answer'
      click_button('Create')
      expect(page).to have_content "Test answer"

      within '.answer-comments' do
      click_link('Add comment')
      end
    end

    scenario 'show/hide form for create a comment for answer', js: true do
      expect(page).to have_content 'Hide comment'
      within "#comments-form-answer_#{Answer.last.id}" do
        expect(page).to have_content 'Body'
      end
      within ".answer-comments" do
        expect(page).to have_selector(:link_or_button, 'Create')
      end
    end

    scenario 'add a comment for answer', js: true do
      fill_in 'comment[body]', with: 'Test comment'
      within ".answer-comments" do
        click_on 'Create'
      end
       sleep 0.5
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
