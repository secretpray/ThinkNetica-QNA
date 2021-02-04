FactoryBot.define do
  factory :question do
    association :user
    title { "MyString" }
    body { "MyText" }

    trait :invalid do
      title { nil }
    end

    trait :with_file do
      files { fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'text/rb')}
    end

    trait :with_link do
      after(:create) do |question|
        create(:link, linkable: question)
      end
    end
  end
end
