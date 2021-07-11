class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable, :confirmable,
         :recoverable, :rememberable,
         :validatable, :omniauthable,
         omniauth_providers: %i[facebook github google_oauth2]

  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :rewards, dependent: :destroy
  has_many :votes, dependent: :destroy

  validates :email, presence: true

  def author?(resource)
    self.id == resource.user_id
  end

  def score(votable)
    votes = votable.votes.where(user_id: id)
    votes.sum(:score)
  end

  def admin?
    self.role == 'admin'
  end

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end

  def subscribed?(question)
    subscriptions.find_by(question_id: question.id).present?
  end
end
