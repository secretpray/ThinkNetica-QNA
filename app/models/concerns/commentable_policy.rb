module CommentablePolicy
  extend ActiveSupport::Concern

  def comment?
    user
  end
end