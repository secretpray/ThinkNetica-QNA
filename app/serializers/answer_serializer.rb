class AnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :body, :created_at, :updated_at, :files
  belongs_to :question
  belongs_to :user
  has_many :comments
  has_many :links

  def files
    object.files.map{|file| rails_blob_url(file, only_path: true )}
  end
end
