FactoryBot.define do
  factory :reward do
    name { "Reward" }

    trait :with_image do
      badge_image { fixture_file_upload(Rails.root.join('spec/support/files', 'reward.png'), 'text/rb') }
    end
  end
end