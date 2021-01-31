class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable
  has_many_attached :files

  accepts_nested_attributes_for :links, allow_destroy: true, reject_if: :all_blank

  validates :title, :body, presence: true

  scope :by_answers_count, -> { joins(:answers).group("questions.id").order("count(questions.id) DESC") }

end
