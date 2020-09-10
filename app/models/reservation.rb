class Reservation < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :room

  # Validations
  validates_presence_of :start_time
  validates_presence_of :end_time
end
