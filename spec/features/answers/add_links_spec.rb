require "rails_helper"

feature "User can add links to a answers", %q{
  In order to provide additional info
  As an answer's author
  I'd like to be able to add links
} do

  describe "Authenticated user", js: true do

    given(:user) { create :user }
    given!(:question) { create :question }
    given(:link_url) { "http://www.google.com" }
    given(:invalid_link_url) { "invalid.site" }

    background do
      sign_in user
      visit question_path(question)

      within "#new_answer" do
        fill_in "answer[body]", with: "New Answer"
        click_on "Add Links"
        fill_in "Name", with: "Google link"
      end
    end

    scenario "User adds valid link", js: true do
      within "#new_answer" do
        fill_in "URL", with: link_url

        click_on "Create"
      end
      within "#answer_list" do
        expect(page).to have_link "Google link", href: link_url
      end
    end

    scenario "User adds invalid link", js: true do
      within "#new_answer" do
        fill_in "URL", with: invalid_link_url

        click_on "Create"
      end
      expect(page).to have_content "Links url is invalid"
    end
  end
end