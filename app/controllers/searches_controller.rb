class SearchesController < ApplicationController

  def index
    params = searched_params
    return redirect_to :root, notice: 'Search request is empty' unless params[:query].present?

    @result = SearchService.call(query: params[:query], type: params[:type])
  end

  private

  def searched_params
    params.permit(:query, :type)
  end
end
