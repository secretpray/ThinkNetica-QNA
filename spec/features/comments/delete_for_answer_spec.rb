require 'rails_helper'
require 'capybara/apparition'

feature 'User can delete his comment', %q{
  In order to correct mistakes
  As an author of comment
  I'd like ot be able to delete my comment
} do

  given(:user) {create(:user)}
  given(:non_author_user) {create(:user)}
  given!(:question) { create(:question) }

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
      fill_in 'comment[body]', with: 'Test comment'
      within ".answer-comments" do
        click_on 'Create'
      end
      expect(page).to have_content "Test comment"
    end

    scenario 'delete a comment', js: true do
      within "#commnet-info_#{Comment.last.id}" do
        accept_confirm do
          click_link('Delete')
        end
      end
      expect(page).to_not have_content "Test comment"
    end
  end

  describe 'Unauthenticated user ' do
    background do
      sign_in(user)
      visit question_path(question)
      fill_in 'answer[body]', with: 'Test answer'
      click_button('Create')
      expect(page).to have_content "Test answer"

      within '.answer-comments' do
      click_link('Add comment')
      end
      fill_in 'comment[body]', with: 'Test comment'
      within ".answer-comments" do
        click_on 'Create'
      end
      expect(page).to have_content "Test comment"
      click_link "Logout"
    end
  #
    scenario 'tries to remove a comment', js: true do

      visit question_path(question)
      within "#commnet-info_#{Comment.last.id}" do
        expect(page).to_not have_selector(:link_or_button, 'Delete')
      end
    end

    scenario "tries to delete other user's comment", js: true do
      sign_in(non_author_user)
      visit question_path(question)
      expect(page).to_not have_selector(:link_or_button, 'Delete')
    end
  end
end
