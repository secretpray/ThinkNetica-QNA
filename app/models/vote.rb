class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates_numericality_of :score
  validates :score, presence: true, inclusion: { in: [1, -1] }
  validates :user, uniqueness: { scope: [:votable_id, :votable_type], message: "** DOUBLE ERROR **" }  # default error message: “has already been taken”.

  scope :upvotes, -> { where(score: 1) }
  scope :downvotes, -> { where(score: -1) }
  end
