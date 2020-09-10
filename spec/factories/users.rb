FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    password { Faker::Books::Lovecraft.deity }
    email { Faker::Internet.unique.email }

    factory :admin do
      admin { true }
    end
  end
end
