require 'rails_helper'

feature 'The user can view the list of questions.', %q{
  In order to get answer from a community
  Any visitor can view the question and answers to it
  I`d like to see a list of all questions
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user_id: user.id) }

  scenario 'Authenticated user can view the question and answers to it' do
    sign_in(user)
    content_check
  end

  scenario 'Unauthenticated user also can view the list of questions' do
    content_check
  end

  def content_check
    visit question_path(question.id)
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer.body
  end
end

