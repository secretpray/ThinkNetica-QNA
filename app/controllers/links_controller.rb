class LinksController < ApplicationController
  
  def destroy
    @link = Link.find(params[:id])
    authorize @link.linkable
    @link.destroy
  end
end