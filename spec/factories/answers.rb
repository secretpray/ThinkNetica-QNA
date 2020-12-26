FactoryBot.define do
  factory :answer do
    body { "MyText" }
    question { nil }

    trait :invalid do
      body { nil }
    end
  end
end
