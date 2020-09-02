class ApplicationController < ActionController::API
  before_action :authorized

  SECRET_KEY = Rails.application.secrets.secret_key_base

  def encode_token(payload)
    JWT.encode(payload, SECRET_KEY)
  end

  def auth_header
    request.headers['Authorization']
  end

  def decoded_token
    if auth_header
      token = auth_header.split(' ')[1]
      # header: { 'Authorization': 'Bearer <token>' }
      begin
        JWT.decode(token, SECRET_KEY, true, { algorithm: 'HS256' })
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def logged_in_user
    if decoded_token
      user_id = decoded_token[0]['user_id']
      @user = User.find_by(id: user_id)
    end
  end

  def logged_in?
    !!logged_in_user
  end

  def authorized
    error_json = { error: 'Please log in.' }
    render json: error_json, status: :unauthorized unless logged_in?
  end
end
