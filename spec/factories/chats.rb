FactoryBot.define do
  factory :chat do
    association :user_a, factory: :user
    association :user_b, factory: :user
  end
end
