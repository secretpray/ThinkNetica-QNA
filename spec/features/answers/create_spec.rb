require 'rails_helper'

feature 'User can give an answer', %q{
  In order to share my knowledge
  As an authenticated user
  I want to be able to create answers
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user' do
    
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'can create answer', js: true do
      fill_in 'answer_body', with: 'Own answer'
      attach_file 'answer_files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Own answer'
      expect(page).to have_link "rails_helper.rb"
      expect(page).to have_link "spec_helper.rb"
    end

    scenario 'Authenticated user creates answer with errors', js: true do

      click_on 'Create'
      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to create answer with attached files" do
      fill_in "answer_body", with: "New Answer"
      attach_file "answer_files", %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]
      within "#new_answer" do
        click_on "Create"
      end

      within "#answer_list" do
        expect(page).to have_link "rails_helper.rb"
        expect(page).to have_link "spec_helper.rb"
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario "can`t create answer" do
      visit question_path(question)

      expect(page).to_not have_content "Create"
      expect(page).to have_content 'You need to Sign in or Register to answer or leave a comment!'
    end
  end
end
