FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    password { Faker::Books::Lovecraft.deity }
    email { Faker::Internet.unique.email }
  end
end
