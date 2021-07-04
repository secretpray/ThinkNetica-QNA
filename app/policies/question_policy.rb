class QuestionPolicy < ApplicationPolicy
  include VotePolicy
  include CommentablePolicy

  class Scope < Scope
    def resolve
      scope.all
    end
  end

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
    user && user.id == record.user_id || user.admin?
  end

  def update?
    user && user.id == record.user_id || user.admin?
  end

  def destroy?
    user && user.id == record.user_id || user.admin?
  end
end
