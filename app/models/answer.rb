class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true

  scope :by_add, -> { order(created_at: :desc) }
  scope :by_user, -> { order(user_id: :asc) }
  scope :by_best, -> { order(best: :desc, created_at: :asc) }

  default_scope { by_best }

  def set_best
    Answer.transaction do
      self.question.answers.update_all(best: false)
      self.update(best: true)
    end
  end

end
