class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :rewards, dependent: :destroy

  validates :email, presence: true

  def author?(resource)
    self.id == resource.user_id
  end

  def admin?
    self.role == 'admin'
  end
end
