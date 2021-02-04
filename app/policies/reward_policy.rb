class RewardPolicy < ApplicationPolicy

  attr_reader :user, :reward

  def new?
    user
  end

  def create?
    user
  end

  def edit
    user && user.id == record.user_id || user.admin?
  end

  def update?
    user && user.id == record.user_id || user.admin?
  end

  def destroy?
    user && user.id == record.question.user_id || user.admin?
  end

end