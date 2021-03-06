class AnswerPolicy < ApplicationPolicy
  include VotePolicy
  include CommentablePolicy

  attr_reader :user, :answer

  def index?
    user
  end

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

  def voted?
    user && user.id != record.user_id || user.admin?
  end
end
