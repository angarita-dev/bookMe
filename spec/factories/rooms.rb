FactoryBot.define do
  factory :room do
    name { Faker::GreekPhilosophers.name }
    capacity { rand(1..100) }

    private { true }

    img_url { Faker::Internet.url }
  end
end
