require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do

  given(:user) {create(:user)}

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_link('Ask a question', match: :first)
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'question[body]', with: 'text text text'
      click_on 'Create'

      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    scenario 'asks a question with attached files' do
      fill_in 'Title', with: 'Test question with image'
      fill_in 'question[body]', with: 'text for attachment'
      # attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      attach_file 'question_files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
      expect(page).to have_content 'Test question with image'
      expect(page).to have_content 'text for attachment'
    end

    scenario 'asks a question with errors' do
      click_on 'Create'

      expect(page).to have_content "Title can't be blank"
    end
  end

  describe 'Unauthenticated user ' do
    scenario 'tries to ask a question' do
      visit new_question_path

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
      expect(page).to_not have_content 'Edit'
    end
  end
end
