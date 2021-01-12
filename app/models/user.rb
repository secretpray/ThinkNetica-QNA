class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :questions
  has_many :answers

  validates :email, presence: true

  def author?(resource)
    self.id == resource.user_id
    # models (Current) and Current.user = current_user in resource Controller
    # Current.user.id == resource.user_id
  end
end
