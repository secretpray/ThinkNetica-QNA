class LinkPolicy < ApplicationPolicy

  attr_reader :user, :link

  def destroy?
    object = record.linkable_type.classify.constantize.find(record.linkable_id)
    # object = record.linkable_type == "Answer" ? Answer.find(record.linkable_id) : Question.find(record.linkable_id)
    user && user.id == object.user.id || user.admin?
  end
end
