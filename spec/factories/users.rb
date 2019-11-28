FactoryBot.define do
  factory :user do
    full_name     { Faker::Name.unique.name }
    email         { Faker::Internet.unique.email }
    password      { Faker::Internet.password(min_length: 8) }
    gender        { User.genders.values.sample }
    provider      { 'email' }
    confirmed_at  { Time.zone.now }

    trait :not_confirmed do
      confirmed_at { nil }
    end
  end
end
