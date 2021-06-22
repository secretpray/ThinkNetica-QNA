class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_attachment

  def destroy
    authorize @attachment.record

    @attachment.purge
  end

  private

  def find_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end
end
