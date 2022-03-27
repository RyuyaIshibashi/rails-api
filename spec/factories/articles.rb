FactoryBot.define do
  factory :article do
    title { "Sample article" }
    content { "Sample content" }
    sequence(:slug) { |n| "sample-slug-#{n}"}
  end
end
