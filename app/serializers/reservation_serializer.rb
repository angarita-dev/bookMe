class ReservationSerializer < ActiveModel::Serializer
  attributes :id, :start_time, :end_time

  has_one :room
end
