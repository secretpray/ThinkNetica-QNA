FactoryBot.define do
  factory :answer do
    association :user
    association :question
    body { "MyText" }

    trait :invalid do
      body { nil }
    end

    trait :with_file do
      files { fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'text/rb')}
    end
  end
end
