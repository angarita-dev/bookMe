class RoomsController < ApplicationController
  def index
    render json: Room.all, status: :ok
  end

  def show
    params = request_params
    @room = Room.where(id: params[:id])

    if !@room.empty?
      response_json = @room.first
      response_status = :ok
    else
      response_json = { error: 'Wrong room id' }
      response_status = :bad_request
    end

    render json: response_json, status: response_status
  end

  private

  def request_params
    params.permit(:id)
  end
end
