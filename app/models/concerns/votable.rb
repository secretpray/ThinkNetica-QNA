module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def rating
    votes.sum(:score)
  end

  private
  
  # def make_vote(user, score)
  # return if user.author?(self)
  #   transaction do
  #     vote = votes.find_or_initialize_by(user: user)
  #     vote.update!(user: user, score: score)
  #   end
  # end
end
