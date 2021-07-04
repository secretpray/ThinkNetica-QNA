class AttachmentSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :url

  def name
    object.filename.to_s
  end

  def url
    rails_blob_path(object, only_path: true)
  end
end
