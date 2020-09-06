class ReservationsController < ApplicationController
  def index
    serialized_reservations = @user.reservations.all.map do |reservation|
      ReservationSerializer.new(reservation).to_h
    end
    response_json = { reservations: serialized_reservations }
    status_code = :ok

    render json: response_json, status: status_code
  end

  def show
    params = reservations_params

    reservation = Reservation.where(id: params[:id])

    if !reservation.empty?
      response_json = { reservation: ReservationSerializer.new(reservation.first) }
      response_code = :ok
    else
      response_json = { error: 'Wrong reservation id' }
      response_code = :bad_request
    end

    render json: response_json, status: response_code
  end

  def create
    params = reservations_create_params

    start_time = parse_date params['start_time']
    end_time = parse_date params['end_time']

    room = Room.where(id: params['room_id'])

    reservation = @user.reservations.new(
      start_time: start_time,
      end_time: end_time,
      room: room.first
    )

    if reservation&.valid?
      reservation.save
      response_json = { reservation: ReservationSerializer.new(reservation) }
      response_code = :created
    else
      response_json = { error: 'Missing or invalid params' }
      response_code = :bad_request
    end

    render json: response_json, status: response_code
  end

  def destroy
    params = reservations_params

    @reservation = @user.reservations.where(id: params[:id])

    if !@reservation.empty?
      @reservation.first.destroy
      response_json = {}
      response_code = :no_content
    else
      response_json = { error: 'Wrong reservation id' }
      response_code = :bad_request
    end

    render json: response_json, status: response_code
  end

  private

  def parse_date(date_string)
    DateTime.iso8601(date_string)
  rescue StandardError
    false
  end

  def reservations_params
    params.permit(:id)
  end

  def reservations_create_params
    params.permit(:room_id, :start_time, :end_time)
  end
end
