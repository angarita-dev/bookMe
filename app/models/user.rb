class User < ApplicationRecord
  # Associations
  has_many :reservations, dependent: :destroy
  has_many :rooms, :through => :reservations

  # Secure password
  has_secure_password

  # Validations
  validates_presence_of :name
  validates_presence_of :password_digest
end
