FactoryBot.define do
  factory :user do
    full_name     { Faker::Name.unique.name }
    email         { Faker::Internet.unique.email }
    password      { Faker::Internet.password(min_length: 8) }
    provider      { 'email' }
    uid           { Faker::Internet.uuid }
    confirmed_at  { Time.zone.now }

    trait :not_confirmed do
      confirmed_at { nil }
    end
  end
end
