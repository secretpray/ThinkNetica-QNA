class CommentPolicy < ApplicationPolicy

  def delete_comment?
    user && user.id == record.user_id || user.admin?
  end

  def delete?
    user && user.id == record.user_id || user.admin?
  end

  def create_comment?
    user
  end
end
