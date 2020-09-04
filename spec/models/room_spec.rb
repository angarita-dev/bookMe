require 'rails_helper'

RSpec.describe Room, type: :model do
  it { should have_many(:reservations).dependent(:destroy) }
  it { should have_many(:users) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:capacity) }

  it 'is not valid with capacity 0' do
    room = Room.new(name: 'name_example', private: false, capacity: 0)

    expect(room).to_not be_valid
  end

  it 'is not valid with capacity < 0' do
    room = Room.new(name: 'name_example', private: false, capacity: -2)

    expect(room).to_not be_valid
  end
end
