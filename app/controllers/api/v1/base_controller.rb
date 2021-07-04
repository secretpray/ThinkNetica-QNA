class Api::V1::BaseController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :doorkeeper_authorize!#, unless: :user_signed_in?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  rescue_from ActiveRecord::RecordNotFound do
    head :not_found
  end

  private

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  alias current_user current_resource_owner

  def user_not_authorized
    Rails.logger.debug "You are not authorized to perform this action."
    render json: { error: "You are not authorized to perform this action." }, status: :forbidden
  end
end
