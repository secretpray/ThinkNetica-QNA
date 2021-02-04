FactoryBot.define do
  sequence :name do |n|
    "Best answer reward ##{n}"
  end

  factory :reward do
    name
    question
    user { nil }

    trait :with_image do
      badge_image { Rack::Test::UploadedFile.new('spec/support/files/reward.png') }
    end
  end
end