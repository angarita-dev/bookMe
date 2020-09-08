class UsersController < ApplicationController
  skip_before_action :authorized, only: %i[create login]

  def create
    user_params.require(%i[name email password password_confirmation])

    @user = User.create(user_params)
    if @user.valid?
      token = encode_token({ user_id: @user.id, user_admin: @user.admin })

      response_json = { user: UserSerializer.new(@user), token: token }
      response_code = :created
    else
      response_json = { error: "Couldn't create account" }
      response_code = :bad_request
    end

    render json: response_json, status: response_code
  end

  def login
    params = user_params
    @user = User.find_by(email: params[:email])

    if @user&.authenticate(params[:password])
      token = encode_token({
                             user_id: @user.id,
                             user_admin: @user.admin
                           })
      response_json = { user: UserSerializer.new(@user), token: token }
      response_code = :ok
    else
      response_json = { error: 'Incorrect credentials' }
      response_code = :unauthorized
    end

    render json: response_json, status: response_code
  end

  def update
    if @user.update(user_params)
      response_json = { user: UserSerializer.new(@user) }
      response_code = :ok
    else
      response_json = { error: 'Changes are not valid' }
      response_code = :bad_request
    end

    render json: response_json, status: response_code
  end

  def destroy
    render json: { user: UserSerializer.new(@user.delete) }, status: :ok
  end

  private

  def check_params(params, keys)
    keys.all? { |key| params.key? key }
  end

  def user_params
    params.permit(:email, :name, :password, :password_confirmation)
  end
end
