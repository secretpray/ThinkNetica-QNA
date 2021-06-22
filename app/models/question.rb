class Question < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :user
  has_one :reward, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many_attached :files

  accepts_nested_attributes_for :links, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  scope :recent, -> { order(created_at: :desc) }
  scope :by_answers_count, -> { joins(:answers).group("questions.id").order("count(questions.id) DESC") }

end
