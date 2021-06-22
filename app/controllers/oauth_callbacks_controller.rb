class OauthCallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2
    authorization('Google')
  end

  def facebook
    authorization('Facebook')
  end

  def github
    authorization('GitHub')
  end


  def authorization(provider)
    # render json: request.env['omniauth.auth']
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user&.persisted? && !@user.email.include?('uid_')
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    elsif @user&.persisted? && @user.email.include?('uid_')
      render 'confirmations/email', locals: { resource: @user }
    else
      flash[:alert] = 'There was a problem signing you in through Facebook. Please register or try signing in later.'
      # redirect_to new_user_registration_url
      redirect_to root_path
    end
  end

  def failure
    flash[:alert] = 'There was a problem signing you in. Please register or try signing in later.'
    redirect_to new_user_registration_url
  end
end
