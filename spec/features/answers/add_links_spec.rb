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
    given(:gist_link_url) { '<script src="https://gist.github.com/secretpray/2bac142504cbc05988fe19521c7c086a.js"></script>' }

    background do
      sign_in user
      visit question_path(question)

      within "#new_answer" do
        fill_in "answer[body]", with: "New Answer"
        click_on "Add Links"
        fill_in "Name", with: "New link"
      end
    end

    scenario "User adds valid link", js: true do
      within "#new_answer" do
        fill_in "URL", with: link_url

        click_on "Create"
      end
      within "#answer_list" do
        expect(page).to have_link "New link", href: link_url
        expect(page).to_not have_content "Show gist"
      end
    end

    scenario "User adds valid Gist link", js: true do
      within "#new_answer" do
        fill_in "URL", with: gist_link_url

        click_on "Create"
      end
      within "#answer_list" do
        expect(page).to have_content "New link"
        expect(page).to_not have_link "New link"
        expect(page).to have_content "Show gist"
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
