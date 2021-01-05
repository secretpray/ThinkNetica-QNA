FactoryBot.define do
  factory :answer do
    association :user
    association :question
    body { "MyText" }
    # question { nil }

    trait :invalid do
      body { nil }
    end
  end
end
