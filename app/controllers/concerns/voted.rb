module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[upvote downvote resetvote]
  end

  def upvote
    # return @votable.errors.add(:base, "You have already voted for!") unless acceptance_score <= 0
    if acceptance_score <= 0
      vote(1)
    else
      render json: { type: votable_type(@votable), error: 'You have already voted for!' }, status: 422
    end
  end

  def downvote
    if acceptance_score >= 0
      vote(-1)
    else
      render json: { type: votable_type(@votable), error: 'You have already voted against!' }, status: 422
    end
  end

  def resetvote
    # binding.pry
    if acceptance_score != 0
      vote(0) 
    else
      render json: { type: votable_type(@votable), error: 'Voting has already been canceled' }, status: 422
      # @votable.errors.add(:base, "Voting has already been canceled")
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def vote(value)
    # add policy
    # binding.pry
    if current_user.author?(@votable)
      render json: { type: votable_type(@votable), error: 'You cannot vote for yourself' }, status: 422
    else
      # @votable.votes.create!(score: value, user: current_user)
      vote = @votable.votes.find_or_initialize_by(user: current_user)
      vote.update!(user: current_user, score: value)
 
      render json: { id: @votable.id, type: votable_type(@votable), rating: @votable.rating }
    end
  end

  def votable_type(obj)
    obj.class.name.downcase
  end

  def acceptance_score
    votes = @votable.votes.where(user_id: current_user.id)
    votes.sum(:score)
  end
end