module RequestSpecHelper
  # Parsing json for controller specs
  def json
    JSON.parse(response.body)
  end

  # Generates token given an email & password
  def login(user_email, user_password)
    post '/users/login', params: { email: user_email, password: user_password }

    json['token']
  end

  # Generates headers given a token
  def token_headers(token)
    { 'Authorization': "Bearer #{token}" }
  end
end
