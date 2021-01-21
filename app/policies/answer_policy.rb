class AnswerPolicy < ApplicationPolicy

  attr_reader :user, :answer

  def new?
    user
  end

  def create?
    user
  end

  def edit
    # user && user == record.user || user.admin?
    user && user.id == record.user_id || user.admin?
  end

  def best?
    # user && user == record.question.user || user.admin?
    user && user.id == record.question.user_id || user.admin?
  end

  def update?
    user && user.id == record.user_id || user.admin?
  end

  def destroy?
    user && user.id == record.user_id || user.admin?
  end

end
