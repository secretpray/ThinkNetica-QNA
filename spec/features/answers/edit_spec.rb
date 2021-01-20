require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user_id: user.id) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end


  describe 'Authenticated user' do
    background do
      sign_in(user)
    end

    scenario 'edits his answer', js: true do
      question.user_id = user.id

      visit question_path(question)
      click_on('Edit', match: :first)

      within '#answer_list' do
        fill_in 'answer_body', with: 'edited answer'
      end
      click_on 'Update'

      expect(page).to have_content answer.body
      expect(page).to have_content 'edited answer'
      expect(page).to have_selector 'textarea'
    end

    scenario 'edits his answer with errors', js: true do
      question.user_id = user.id

      visit question_path(question)
      click_on('Edit', match: :first)

      within '#answer_list' do
        fill_in 'answer_body', with: ''
      end
      click_on 'Update'

      expect(page).to have_content 'MyText'
      expect(page).to have_content "Body can't be blank"
      expect(page).to_not have_content 'edited answer'
      expect(page).to have_selector 'textarea'
    end

    scenario "tries to edit other user's answer" do
      answer.user_id += 1

      visit question_path(question)
      expect(page).to have_content answer.body
      expect(page).to_not have_content 'edited answer'
    end
  end
end
