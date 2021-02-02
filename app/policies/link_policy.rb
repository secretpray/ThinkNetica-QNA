class LinkPolicy < ApplicationPolicy

  # attr_reader :user, :attachment

  def destroy?
    user && user.id == record.user_id || user.admin?
  end

end
