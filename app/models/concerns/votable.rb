module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  VOTE_DATA = ['upvote', 'downvote']

  def rating
    votes.sum(:score)
  end

  def get_value(action_name, current_score)
    return unless action_name.in? VOTE_DATA
    if action_name == 'upvote' 
      current_score <= 0 ? 1 : nil
      # current_score.negative? || current_score.zero? ? 1 : nil
    else
      current_score >= 0 ? -1 : nil
    end
  end

  def make_vote(user, value)
    vote = votes.find_or_initialize_by(user: user)
    vote.update!(user: user, score: value)
  end
end
