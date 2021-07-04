class Api::V1::ProfilesController < Api::V1::BaseController
  # respond_to :json

  def other
    profiles = User.where.not(id: current_resource_owner.id)

    render json: profiles, each_serializer: ProfileSerializer
  end

  def me
    render json: current_resource_owner, serializer: ProfileSerializer
  end
end
