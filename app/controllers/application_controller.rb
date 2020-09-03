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
    return decode_token if auth_header
  end

  def logged_in_user
    return user_from_token if decoded_token
  end

  def logged_in?
    !logged_in_user.nil?
  end

  def authorized
    error_json = { error: 'Please log in.' }
    render json: error_json, status: :unauthorized unless logged_in?
  end

  def admin?
    admin_from_token
  end

  def admin_authorized
    error_json = { error: 'Admin only action' }
    render json: error_json, status: :unauthorized unless admin?
  end

  private

  def decode_token
    token = auth_header.split(' ')[1]
    # header: { 'Authorization': 'Bearer <token>' }
    begin
      JWT.decode(token, SECRET_KEY, true, { algorithm: 'HS256' })
    rescue JWT::DecodeError
      nil
    end
  end

  def user_from_token
    user_id = decoded_token[0]['user_id']
    @user = User.find_by(id: user_id)
  end

  def admin_from_token
    decoded_token[0]['user_admin']
  end
end
