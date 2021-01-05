require 'rails_helper'

feature 'User can log out', %q{
  In order to ask questions
  As an authenticated user
  I'd like to be able to log out
} do

  given(:user) { create(:user) }

  background { visit new_user_session_path }

  scenario 'Authenticated user tries to log out' do
    sign_in(user)

    click_on 'Home'
    click_link "Logout"

    logout_content
  end

  scenario 'Unauthenticated user tries to log out' do
    click_on 'Home'
    expect(page).to_not have_content('Logout')
    logout_content
  end
end
