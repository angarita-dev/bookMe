require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user_password) { 'S3cur3_@_p4ssw0rd' }
  let!(:user) { create(:user, password: user_password) }
  let!(:room) { create(:room) }
  let!(:reservation) do
    create(
      :reservation,
      user: user,
      room: room,
      start_time: DateTime.current,
      end_time: DateTime.current + 2.hours
    )
  end

  let(:user_email) { user.email }
  let(:reservation_id) { reservation.id }
  let(:user_token) { login user_email, user_password }


  describe 'POST /users #create' do
    valid_attributes = {
      name: 'Jhon Doe',
      email: 'testemail@email.com',
      password: 's3cur3_p4ssw0rd'
    }

    invalid_attributes = { name: 'Jhon Doe', password: 's3cur3_p4ssw0rd' }

    context 'valid' do
      before { post '/users', params: valid_attributes }

      it 'creates user' do
        created_user = User.last
        user = json['user']
        expect(user['email']).to eq(created_user.email)
      end

      it "creates doesn't return password_digest" do
        user = json['user']
        expect(user['password_digest']).not_to exist
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'Missing params' do
      before { post '/users', params: invalid_attributes }

      it 'fails to create user' do
        expect(json['error']).to eq('Missing fields')
      end

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end
    end
  end

  describe 'POST /users/login #login' do
    context 'valid login' do
      before do
        post '/users/login', params: { email: user.email, password: user_password }
      end

      it 'logs in' do
        user = json['user']
        expect(user['email']).to eq(user_email)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'invalid login' do
      before do
        post '/users/login',
          params: { email: user.email, password: 'wrong_password' }
      end

      it 'returns incorrect credentials error' do
        expect(json['error']).to eq('Incorrect credentials')
      end

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET /users/reservations #index', :focus do
    context 'valid' do
      before do
        get '/users/reservations',
          headers: token_headers(user_token)
      end

      it 'returns user reservation list' do
        expect(json).to_not be_empty
        expect(json.size).to eq(user.reservations.count)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'user not logged in' do
      before { get '/users/reservations' }

      it 'returns error message' do
        expect(json['error']).to eq('Please log in.')
      end

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET /users/reservation #show' do
    context 'valid' do
      before do
        get "/users/reservations/#{reservation_id}",
          headers: token_headers(user_token)
      end

      it 'returns reservation' do
        expect(json).to_not be_empty
        expect(json['id']).to eq(reservation_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'user not logged in' do
      before { get "/users/reservations/#{reservation_id}" }

      it 'returns error message' do
        expect(json['error']).to eq('Please log in.')
      end

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end

    context 'invalid reservations index' do
      before do
        get "/users/reservations/#{reservation_id + 1}",
          headers: token_headers(user_token)
      end

      it 'returns error message' do
        expect(json['error']).to eq('Wrong reservation id')
      end

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end
    end
  end

  describe 'DELETE /users/reservation #destroy' do
    context 'valid' do
      before do
        delete "/users/reservations/#{reservation_id}",
          headers: token_headers(user_token)
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'user not logged in' do
      before { delete "/users/reservations/#{reservation_id}" }

      it 'returns error message' do
        expect(json['error']).to eq('Please log in.')
      end

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end

    context 'invalid reservation id' do
      before do
        delete "/users/reservations/#{reservation_id + 1}",
          headers: token_headers(user_token)
      end

      it 'returns error message' do
        expect(json['error']).to eq('Wrong reservation id')
      end

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end
    end
  end
end
