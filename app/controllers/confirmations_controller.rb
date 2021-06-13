class ConfirmationsController < Devise::ConfirmationsController
  before_action :find_user, only: [:create]

  def create
    if @user.update(user_params)
      @user.send_confirmation_instructions
      redirect_to root_path, alert: 'Please confirm your email'
    else
      going_wrong
    end
  end

  private

  def after_confirmation_path_for(resource_name, resource)
    if signed_in?(@user)
      signed_in_root_path(@user)
    else
      new_session_path(@user)
    end
  end

  def going_wrong
    if params[:user][:email].blank?
      flash.now[:alert] = 'Email can not be blank!'
      render 'confirmations/email', locals: { resource: @user }
    else
      multiple_accounts
    end
  end

  def multiple_accounts
    @old_user = User.find_by(email: params[:user][:email])
    @authorization = Authorization.find_by(user_id: @user).update(user_id: @old_user.id)
    @user.delete
    @old_user.update(confirmed_at: nil)
    @old_user.send_confirmation_instructions
    redirect_to new_session_path(@old_user), notice: "Welcome back, #{@old_user.email}!"
  end

  def find_user
    @user = User.find(params[:user_id])
  end

  def user_params
    params.require(:user).permit(:email)
  end
end
