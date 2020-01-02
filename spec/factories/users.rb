FactoryBot.define do
  factory :user do
    full_name               { Faker::Name.unique.name }
    email                   { Faker::Internet.unique.email }
    password                { Faker::Internet.password(min_length: 8) }
    password_confirmation   { password }
    gender                  { User.genders.keys.sample }
    provider                { 'email' }
    uid                     { email }
    confirmed_at            { Time.zone.now }
    avatar { Rack::Test::UploadedFile.new('spec/fixtures/download.jpeg', 'image/jpeg') }

    trait :not_confirmed do
      confirmed_at { nil }
    end
  end
end
