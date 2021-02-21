module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[upvote downvote resetvote]
    before_action :set_value, only: %i[upvote downvote]
  end
  
  def upvote
    authorize @votable
    return result_error unless @value
    
    @votable.make_vote(current_user, @value)
    result_success
  end

  def downvote
    authorize @votable
    return result_error unless @value
    
    @votable.make_vote(current_user, @value)
    result_success
  end

  def resetvote
    authorize @votable
    @votable.votes.find_by(user_id: current_user.id).try(:destroy)
    result_success
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def votable_type(obj)
    obj.class.name.downcase
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def set_value
    current_score = current_user.score(@votable)
    @value = @votable.get_value(action_name, current_score) 
  end

  def result_success
    render json: { 
      id: @votable.id, 
      type: votable_type(@votable), 
      rating: @votable.rating,
      row_html: render_html_content(partial: "shared/vote", layout: false, locals: {resource: @votable})
    }
  end

  def result_error
    render json: { 
      id: @votable.id, 
      type: votable_type(@votable), error: 'You have already voted!' 
    }, status: 422
  end
end