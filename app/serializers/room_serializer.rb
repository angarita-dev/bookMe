class RoomSerializer < ActiveModel::Serializer
  attributes :id, :name, :private, :capacity, :img_url, :amenities

  belongs_to :reservations
end
