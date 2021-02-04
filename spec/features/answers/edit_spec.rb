require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user_id: user.id) }
  given(:link_url) { "http://www.google.com" }
  given(:gist_link_url) { '<script src="https://gist.github.com/secretpray/2bac142504cbc05988fe19521c7c086a.js"></script>' }


  describe 'Unauthenticated user' do
    scenario 'can`t edit answer & delete attachment' do
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
      expect(page).to_not have_content 'Remove'
    end
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
        attach_file "answer_files", %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]
        click_on "Add Links"
        fill_in "Name", with: "New link"
        fill_in "URL", with: link_url
      end
      click_on 'Update'

      within '#answer_list' do
        expect(page).to have_content 'edited answer'
        expect(page).to have_link "rails_helper.rb"
        expect(page).to have_link "spec_helper.rb"
        expect(page).to have_link "New link", href: link_url
        expect(page).to_not have_content "Show gist"
      end
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
      expect(page).to_not have_content 'Remove'
      expect(page).to_not have_link 'Delete Link'
    end
  end
end
