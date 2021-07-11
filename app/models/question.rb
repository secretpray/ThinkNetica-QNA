class Question < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :user
  has_one :reward, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many_attached :files

  accepts_nested_attributes_for :links, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true
  after_commit :subscribe, on: :create

  scope :recent, -> { order(created_at: :desc) }
  scope :yesterday, -> { where('created_at > ?', Date.yesterday) }
  scope :by_answers_count, -> { joins(:answers).group("questions.id").order("count(questions.id) DESC") }

  private

  def subscribe
    subscriptions.create!(user: user) # @question.send(:subscribe)
    # Subscription.create!(user: user, question: self)
  end

end
