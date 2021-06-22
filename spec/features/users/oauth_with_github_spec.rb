require 'rails_helper'

feature 'User can sign in with GitHub authorization', %q(
  "In order to ask questions as an unauthenticated user
   I'd like to able to sign in"
) do
  given!(:user) { create(:user, email: 'oauth@mail.com') }

  background { visit new_user_registration_path }

  describe 'Registered user' do
    scenario 'try to sign in' do
      mock_auth_hash('github', email: 'oauth@mail.com')
      click_on 'Github'
      # save_and_open_page
      # expect(page).to have_content 'You have to confirm your email address before continuing.'
      expect(page).to have_content 'Successfully authenticated from GitHub account.'
    end

    scenario 'try to sign in with failure' do
      clean_mock_auth('github')
      failure_mock_auth('github')
      click_on 'Github'
      expect(page).to have_content 'There was a problem signing you in. Please register or try signing in later.'
    end
  end

  describe 'Unregistered user' do
    background do
      clean_mock_auth('github')
      mock_auth_hash('github', email: 'oauth1@mail.com')
    end

    scenario 'try to sign in' do
      click_on 'Github'

      expect(page).to have_content 'You have to confirm your email address before continuing'
    end

    scenario 'try to sign in with confirmation' do
      click_on 'Github'
      expect(page).to have_content 'You have to confirm your email address before continuing'

      open_email('oauth1@mail.com')
      current_email.click_link 'Confirm my account'
      click_link('Github')

      expect(page).to have_content 'Successfully authenticated from GitHub account'
    end

    scenario 'try to sign in with failure' do
      clean_mock_auth('github')
      failure_mock_auth('github')

      click_link('Github')
      expect(page).to have_content 'There was a problem signing you in. Please register or try signing in later.'
    end
  end
end
