FactoryBot.define do
  factory :target do
    topic
    title { Faker::Artist.name }
    radius { Faker::Number.within(range: 1..1000) }
    latitude { Faker::Address.latitude.round(11) }
    longitude { Faker::Address.longitude.round(11) }
  end
end
