class Reward < ApplicationRecord
    belongs_to :question
    belongs_to :user, optional: true
  
    has_one_attached :badge_image
  
    validates :name, presence: true
  end