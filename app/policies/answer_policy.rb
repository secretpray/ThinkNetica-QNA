class AnswerPolicy < ApplicationPolicy

  attr_reader :user, :answer

  def new?
    user
  end

  def create?
    user
  end

  def edit
    user && user == record.user || user.role == user.admin?
  end

  def best?
    user && user == record.question.user || user.admin?
  end

  def update?
    user && user == record.user || user&.admin?
  end

  def destroy?
    user && user == record.user || user.admin?
  end

end
