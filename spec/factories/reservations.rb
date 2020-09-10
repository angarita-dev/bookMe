FactoryBot.define do
  factory :reservation do
    user
    room
    start_time { DateTime.now.iso8601 }
    end_time { (DateTime.now + 2.hours).iso8601 }
  end
end
