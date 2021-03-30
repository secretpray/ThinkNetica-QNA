require "rails_helper"

feature "Author of the question choose best answer", %q{
  As the author of the question
  I can choose best answer
} do
  given(:user) {create(:user)}
  given(:roque) {create(:user)}
  given(:question) {create(:question, user: user)}
  given!(:answer) {create(:answer, question: question, user: user)}
  given!(:other_answer) {create(:answer, question: question, user: user)}


  scenario "Author question choose best answer", js: true do
    sign_in(user)
    visit question_path(question)

    within "#answer_list" do
      click_on('✓ Best', match: :first)

      expect(page).to have_css ".best"
    end
  end

  scenario 'Author question change best answer', js: true do
    sign_in(user)
    visit question_path(question)
    
    within "#answer_list" do
      click_on('✓ Best', match: :first)
    end
    
    within ".answer_#{other_answer.id}" do
      click_on('✓ Best', match: :first)
    end
    
    within "#answer_list" do 
      page.find("#answerBlock_#{other_answer.id}")[:class].include?("best")
    end
  end

  scenario 'Author question choose only one best answer', js: true do
    sign_in(user)
    visit question_path(question)

    within "#answer_list" do
      click_on('✓ Best', match: :first)

      expect(page).to have_css ".best"
      expect(page).to have_content "The best answer"
    end

    within "#answer_list" do
      click_on('✓ Best', match: :first)

      expect(page).to have_css ".best"
      expect(page).to have_content "The best answer"
      expect(page).to have_selector('.best', count: 1)
    end
  end

  scenario "Nonauthor question tries to choose best anser" do
    sign_in(roque)
    visit question_path(question)

    within "#answer_list" do
      expect(page).to have_no_link "✓ Best"
      expect(page).to_not have_content "The best answer"
    end
  end

  scenario "Unauthorized user tries to choose best anser" do
    visit question_path(question)

    expect(page).to have_no_link "✓ Best"
    expect(page).to_not have_content "The best answer"
  end
end
