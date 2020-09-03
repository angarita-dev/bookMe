require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user_password) { 'S3cur3_@_p4ssw0rd' }
  let!(:user) { create(:user, password: user_password) }
  let!(:room) { create(:room) }
  let!(:reservation) do
    create(
      :reservation,
      user: user,
      room: room
    )
  end

  let(:user_email) { user.email }
  let(:user_id) { user.id }
  let(:room_id) { room.id }
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

      it 'returns user serialized' do
        created_user = User.last
        serialized_user = UserSerializer.new(created_user).attributes.stringify_keys

        expect(json['user']).to eq(serialized_user)
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

      it 'returns user serialized' do
        serialized_user = UserSerializer.new(user).attributes.stringify_keys

        expect(json['user']).to eq(serialized_user)
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
end
