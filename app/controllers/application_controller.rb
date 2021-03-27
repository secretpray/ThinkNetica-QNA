class ApplicationController < ActionController::Base
  include HtmlRender
  include Pundit
  protect_from_forgery
  
  before_action :set_gon_user_id

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def set_gon_user_id
    gon.user_id = current_user&.id
    gon.is_admin = current_user&.admin? rescue nil 
  end
  
end
