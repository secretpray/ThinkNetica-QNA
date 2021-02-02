require 'rails_helper'

feature 'The user can view a list of all his rewards.', %q(
"In order to find all my best answers
 I'd like to be able to see list of all my rewards"
) do

  given!(:users) { create_list(:user, 2) }
  given!(:questions) { create_list(:question, 2, user: users.first) }
  given!(:answer) { create(:answer, question: questions.first, user: users.first, best: true) }
  given!(:answer1) { create(:answer, question: questions.last, user: users.first, best: true) }
  given!(:reward) { create :reward, :with_image, question: questions.first, user: users.first }
  given!(:reward1) { create :reward, :with_image, question: questions.last, user: users.first }
  given!(:reward2) { create :reward, :with_image, question: questions.last, user: users.last }
  given!(:reward3) { create :reward, :with_image, question: questions.last }

  scenario 'Authenticated user' do
    sign_in(users.first)
    visit rewards_path

    expect(page).to have_content reward.name
    expect(page).to have_content reward1.name
    expect(page).to_not have_content reward2.name
    expect(page).to_not have_content reward3.name
  end

  describe 'Unauthenticated user 'do
    scenario 'have not link to rewards page' do
      expect(page).not_to have_link 'Rewards'
    end

    scenario 'try to access on rewards page' do
      visit rewards_path

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
