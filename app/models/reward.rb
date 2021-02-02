class Reward < ApplicationRecord
    belongs_to :question
    belongs_to :user, optional: true
  
    has_one_attached :badge_image
  
    validates :name, presence: true
    validates :badge_image, blob: { content_type: ['image/jpg', 'image/jpeg', 'image/png'], size_range: 1..5.megabytes }
 
  end