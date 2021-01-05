module FeatureHelpers
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def content_check
    visit question_path(question.id)
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer.body
  end

  def title_check
    visit root_path
    expect(page).to have_content 'List a question'
    expect(page).to have_content question.title
  end

  def logout_content
    expect(page).to have_content("You need to Sign in or Register to ask question!")
    expect(page).to have_content('Login')
    expect(page).to have_content('Logon')
    expect(page).to_not have_content 'Signed in successfully.'
  end

  def registration_content(wrong = false)
    find(:css, "input[id$='password']").fill_in with: '12345678'
    fill_in 'Password confirmation', with: "12345678#{0 if wrong}"
    click_on 'Sign up'
  end
end
