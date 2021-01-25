class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user

  has_many_attached :files

  validates :title, :body, presence: true

  scope :by_answers_count, -> { joins(:answers).group("questions.id").order("count(questions.id) DESC") }

end
