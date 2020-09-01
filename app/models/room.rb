class Room < ApplicationRecord
  # Associations
  has_many :reservations, dependent: :destroy
  has_many :users, through: :reservations

  # Validations
  validates_presence_of :name
  validates_presence_of :capacity
  validates_numericality_of :capacity, greater_than: 0
  validates_presence_of :private
end
