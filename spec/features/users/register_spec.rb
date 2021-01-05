require 'rails_helper'

feature 'User can register', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to register
} do

  given(:user) { create(:user) }

  background { visit new_user_registration_path }

  scenario 'User tries to login with valid data' do
    expect(page).to have_content 'Sign up'
    fill_in 'Email', with: 'sample@mail.com'
    registration_content # -> module FeatureHelpers

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(page).to have_current_path(root_path)
  end

  scenario 'User tries to login with invalid data (email duplicate)' do
    fill_in 'Email', with: user.email
    registration_content

    expect(page).to have_content 'Please review the problems below:'
    expect(page).to have_content 'has already been taken'
    expect(page).to have_current_path("/users")
  end

    scenario "User tries to login with invalid data (not match Password)" do
    fill_in 'Email', with: user.email
    registration_content(user) # user (fake param) for switch to wrong password confirmation

    expect(page).to have_content 'Please review the problems below:'
    expect(page).to have_content "doesn't match Password"
    expect(page).to have_current_path("/users")
  end
end
