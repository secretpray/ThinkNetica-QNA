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

    trait :with_attached_file do
       after(:create) do |question|
         question.files.attach(io: File.open(Rails.root.join("#{Rails.root}/spec/spec_helper.rb")), filename: 'spec_helper.rb')
       end
     end

     trait :with_attached_files do
       after(:create) do |question|
         question.files.attach(io: File.open(Rails.root.join("#{Rails.root}/spec/spec_helper.rb")), filename: 'spec_helper.rb')
         question.files.attach(io: File.open(Rails.root.join("#{Rails.root}/spec/rails_helper.rb")), filename: 'rails_helper.rb')
       end
     end

     # trait :with_link do
     #   links { [attributes_for(:link)] }
     # end

    trait :with_link do
      after(:create) do |question|
        create(:link, linkable: question)
      end
    end
  end
end
