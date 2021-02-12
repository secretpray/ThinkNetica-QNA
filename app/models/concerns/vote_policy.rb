module VotePolicy
  extend ActiveSupport::Concern

  def upvote?
    current_score = record.votes.where(user_id: user.id).sum(:score) 
    user && user.id != record.user_id && !user.author?(record) && current_score <= 0
  end

  def downvote?
    current_score = record.votes.where(user_id: user.id).sum(:score) 
    user && user.id != record.user_id && !user.author?(record) &&  current_score >= 0
  end

  def resetvote?
    current_score = record.votes.where(user_id: user.id).sum(:score) 
    user && user.id != record.user_id && !user.author?(record) && current_score != 0
  end

  def make_vote?
    user && !user.author?(record)
  end
end