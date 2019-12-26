FactoryBot.define do
  factory :message do
    chat
    user { [chat.user_a, chat.user_b].sample }
    seen { [true, false].sample }
    text { Faker::Coffee.notes }
  end
end
