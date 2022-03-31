FactoryBot.define do
  factory :access_token do
    token { "MyString" }
    user { nil }
    after(:build) do |access_token|
      access_token.user = create :user
    end
  end
end
