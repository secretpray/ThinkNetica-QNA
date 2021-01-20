class QuestionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    user
  end

  def create?
    user
  end

  def edit
    user && user == record.user || user.admin?
  end

  def update?
    user && user == record.user || user.admin?
  end

  def destroy?
    user && user == record.user || user.admin?
  end

end
