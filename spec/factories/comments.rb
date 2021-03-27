FactoryBot.define do
  factory :comment do
    commentable { nil }
    body { "MyText" }
    user { nil }
  end
end
