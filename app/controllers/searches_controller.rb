class SearchesController < ApplicationController

  def index
    return redirect_to :root, alert: 'Request is empty' unless params['request'].present?
    return redirect_to :root, alert: 'Unknown type' unless params['type'].present? || SearchService::TYPES.include?(params['type'])

    @result = SearchService.call(request: params['request'], type: params['type'])
    render :index
  end

  def query_params
    params.permit(:request, :type)
  end
end
