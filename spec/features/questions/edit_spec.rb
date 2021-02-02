require 'rails_helper'

feature 'User can edit question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask and edit the question
} do

  given(:user) {create(:user)}
  given(:another_user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_link('Ask a question', match: :first)
    end

    scenario 'asks a question with errors' do
      click_on 'Create'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'edit the attached file from their question' do
      visit root_path
      click_link('Ask a question', match: :first)
      fill_in 'Title', with: 'Test question'
      fill_in 'question[body]', with: 'text text text'
      attach_file 'question_files', ["#{Rails.root}/spec/rails_helper.rb"]
      click_on 'Create'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_content 'No answers!'

      visit root_path
      click_link 'Edit'
      attach_file 'question_files', ["#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Update'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
      expect(page).to have_content 'No answers!'
    end

    scenario 'edit the badge image from their question' do
      visit root_path
      click_link('Ask a question', match: :first)

      fill_in 'Title', with: 'Test question with reward'
      fill_in 'question[body]', with: 'Body for reward'
      fill_in "Reward`s name", with: 'For the best answer'
      attach_file 'question[reward_attributes][badge_image]', "#{Rails.root}/spec/support/files/reward.png"
      click_on 'Create'

      visit root_path
      click_link 'Edit'
      attach_file 'question[reward_attributes][badge_image]', "#{Rails.root}/spec/support/files/reward_gold.png"
      click_on 'Update'

      expect(page).to have_content 'Reward:' 
      expect(page.find('.reward-image')['src']).to have_content 'reward_gold.png'
    end
  end

  describe 'Authenticated user' do
    scenario "cannot delete a file attached to someone else's question" do
      sign_in(user)
      create(:question, user: user)

      expect(page).to_not have_content 'Edit'
      expect(page).to have_content 'Ask a question'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to ask a question' do
      visit new_question_path

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
      expect(page).to_not have_content 'Edit'
    end
  end
end

