require 'rails_helper'

feature 'The user can view the list of questions.', %q{
  In order to get answer from a community
  Any visitor can view the list of questions
  I`d like to see a list of all questions
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user_id: user.id) }

  scenario 'Authenticated user can view the list of questions' do
    sign_in(user)
    title_check
  end

  scenario 'Unauthenticated user also can view the list of questions' do
    title_check
  end

  def title_check
    visit root_path
    expect(page).to have_content 'List a question'
    expect(page).to have_content question.title
  end
end
