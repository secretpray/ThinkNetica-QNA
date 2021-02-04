class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable
  has_many_attached :files

  accepts_nested_attributes_for :links, allow_destroy: true, reject_if: :all_blank

  validates :body, presence: true

  scope :by_add, -> { order(created_at: :desc) }
  scope :by_user, -> { order(user_id: :asc) }
  scope :by_best, -> { order(best: :desc, created_at: :asc) }

  default_scope { by_best }

  def set_best
    Answer.transaction do
      question.answers&.update_all(best: false)
      update(best: true)
      question.reward&.update!(user: user)
    end
  end
end
