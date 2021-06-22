# RSpec.shared_examples "comment creation" do
#   given(:user) { create(:user) }
#   given(:other_user) { create(:user) }
#   given(:commentable_human_name) { commentable.model_name.human } # "Question" || "Answer" <=> commentable_type
#   given(:commentable_css_name) { commentable.model_name.to_s.underscore.dasherize }

#   background do
#     sign_in(user)
#     using_session('other_user') { sign_in(other_user) }
#   end

#   describe 'Authenticated user' do
#     scenario "tries to write comment for a commentable with filled form", js: true do
#       visit visit_path

#       using_session('other_user') do
#         visit visit_path
#       end

#       using_session('guest') do
#         visit visit_path
#       end
      
      #{params[:commentable_type].downcase.dasherize}-#{@commentable.id}" => "question-11"

      # within ".#{commentable_css_name}-#{commentable.id}-comments" do
      #   click_on 'New comment'
      #   fill_in 'New comment', with: 'my comment'
      #   click_on 'Create Comment'

      #   expect(page).to have_content 'my comment', count: 1
      #   expect(page).to have_link 'New comment'
      #   expect(page).to_not have_css '.new-comment-form'
      # end

      # expect(page).to have_content 'Comment successfully added'

      # using_session('other_user') do
      #   expect(page).to have_content 'my comment'
      # end

      # using_session('guest') do
      #   expect(page).to have_content 'my comment'
      # end
    # end

    # scenario "tries to write comment for a commentable with blank form", js: true do
    #   visit visit_path

      # within ".#{commentable_css_name}-#{commentable.id}-comments" do
      #   click_on 'New comment'
      #   fill_in 'New comment', with: ''
      #   click_on 'Create Comment'

      #   expect(page).to_not have_link 'New comment'
      #   expect(page).to have_css '.new-comment-form'
      #   expect(page).to have_content "Body can't be blank"
      # end
  #   end
  # end

  # scenario 'Unauthenticated user tries to write a comment' do
  #   using_session('guest') do
  #     visit visit_path

    #   within ".#{commentable_css_name}-#{commentable.id}-comments" do
    #     expect(page).to_not have_link 'New comment'
    #     expect(page).to_not have_css '.new-comment-form'
    #   end
    # end
#   end
# end