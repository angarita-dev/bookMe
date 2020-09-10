class RoomsController < ApplicationController
  skip_before_action :authorized, only: %i[index show]
  before_action :admin_authorized, only: %i[update destroy]
  before_action :set_current_room, only: %i[update destroy]

  def index
    serialized_rooms = ActiveModelSerializers::SerializableResource.new(
      Room.all,
      each_serializer: RoomSerializer
    )
    json_response = { rooms: serialized_rooms }
    render json: json_response, status: :ok
  end

  def show
    params = request_params
    @room = Room.where(id: params[:id])

    if !@room.empty?
      response_json = { room: RoomSerializer.new(@room.first) }
      response_status = :ok
    else
      response_json = { error: 'Wrong room id' }
      response_status = :bad_request
    end

    render json: response_json, status: response_status
  end

  def destroy
    render json: { room: RoomSerializer.new(@room.delete) }, status: :ok
  end

  def update
    if @room.update(create_params)
      response_json = { room: RoomSerializer.new(@room) }
      response_code = :ok
    else
      response_json = { error: 'Changes are not valid' }
      response_code = :bad_request
    end

    render json: response_json, status: response_code
  end

  private

  def set_current_room
    id = request_params['id']
    @room = Room.where(id: id).first unless id.nil?

    render json: { error: 'Wrong room id' }, status: :bad_request if @room.nil?
  end

  def request_params
    params.permit(:id)
  end

  def create_params
    params.permit(:name, :private, :capacity, :amenities, :img_url)
  end
end
