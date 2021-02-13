FactoryBot.define do
  factory :vote do
    association :user, factory: :user
    score { 1 }

    trait :for_question do
      association :votable, factory: :question
    end

    trait :for_answer do
      association :votable, factory: :answer
    end
  end
end