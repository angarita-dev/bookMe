require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:reservations).dependent(:destroy) }
  it { should have_many(:rooms) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:password_digest) }
end
