FactoryBot.define do
  factory :site_info do
    info { Faker::Coffee.notes }
  end
end
