class AnswerPolicy < ApplicationPolicy

  attr_reader :user, :answer

  def new?
    user
  end

  def create?
    user
  end

  def edit
    user && user.id == record.user_id || user.admin?
  end

  def best?
    user && user.id == record.question.user_id || user.admin?
  end

  def update?
    user && user.id == record.user_id || user.admin?
  end

  def destroy?
    user && user.id == record.user_id || user.admin?
  end

  def upvote?
    # binding.pry
    current_score = record.votes.where(user_id: user.id).sum(:score) 
    user && user.id != record.user_id && current_score <= 0 || user.admin?
  end

  def downvote?
    # binding.pry
    current_score = record.votes.where(user_id: user.id).sum(:score) 
    user && user.id != record.user_id && current_score >= 0 || user.admin?
  end

  def resetvote?
    # binding.pry
    current_score = record.votes.where(user_id: user.id).sum(:score) 
    user && user.id != record.user_id && current_score != 0 || user.admin?
  end
end
