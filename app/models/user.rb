class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions
  has_many :answers

  validates :email, presence: true

  def author?(resource)
    self.id == resource.user_id
  end
end
