require 'rails_helper'

feature 'User can subscribe to question', %q{
  In order to be notified of new answers for my question
  As an authenticated user
  I'd like to be able to get email notification of new answers for my question
} do

  given(:user) { create :user }
  given(:user2) { create :user }
  given(:question) { create :question, user: user }

  describe 'Authenticated user', js: true do
    scenario 'Question author' do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_content 'Subscribe'
      expect(page).to have_content 'Unsubscribe'

      click_on 'Unsubscribe'

      expect(page).to have_content 'Subscribe'
      expect(page).to_not have_content 'Unsubscribe'

      click_on 'Subscribe'

      expect(page).to_not have_content 'Subscribe'
      expect(page).to have_content 'Unsubscribe'
    end

    scenario 'Non-author' do
      sign_in(user2)
      visit question_path(question)

      expect(page).to have_content 'Subscribe'
      expect(page).to_not have_content 'Unsubscribe'

      click_on 'Subscribe'

      expect(page).to_not have_content 'Subscribe'
      expect(page).to have_content 'Unsubscribe'

      click_on 'Unsubscribe'

      expect(page).to have_content 'Subscribe'
      expect(page).to_not have_content 'Unsubscribe'
    end
  end


  scenario 'Unauthenticated user', js: true do
    visit question_path(question)

    expect(page).to_not have_content 'Subscribe'
    expect(page).to_not have_content 'Unsubscribe'
  end
end
