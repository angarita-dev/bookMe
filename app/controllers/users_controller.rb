class UsersController < ApplicationController
  skip_before_action :authorized, only: %i[create login]

  def create
    @user = User.create(user_create_params)
    if @user.valid?
      token = encode_token({ user_id: @user.id })
      response_json = { user: @user, token: token }
      render json: response_json, status: :created
    else
      missing_params = check_params(
        user_params,
        %i[name email password password_confirmation]
      )

      response_json = if missing_params
                        { error: "Couldn't create account" }
                      else
                        { error: 'Missing fields' }
                      end

      render json: response_json, status: :bad_request
    end
  end

  def login
    params = user_params
    @user = User.find_by(email: params[:email])

    if @user&.authenticate(params[:password])
      token = encode_token({ user_id: @user.id })
      response_json = { user: @user, token: token }
      response_code = :ok
    else
      response_json = { error: 'Incorrect credentials' }
      response_code = :unauthorized
    end

    render json: response_json, status: response_code
  end

  private

  def check_params(params, keys)
    keys.all? { |key| params.key? key }
  end

  def user_create_params
    params.permit(:email, :name, :password, :password_confirmation)
  end

  def user_params
    params.permit(:email, :password)
  end
end

class Users::ReservationsController < ApplicationController
  def index
    response_json = @user.reservations.all
    status_code = :ok

    render json: response_json, status: status_code
  end

  def show
    params = reservations_params

    @reservation = Reservation.where(id: params[:id])

    if !@reservation.empty?
      response_json = @reservation.first
      response_code = :ok
    else
      response_json = { error: 'Wrong reservation id' }
      response_code = :bad_request
    end

    render json: response_json, status: response_code
  end

  def destroy
    params = reservations_params

    @reservation = Reservation.where(id: params[:id])

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

  def reservations_params
    params.permit(:id)
  end
end
