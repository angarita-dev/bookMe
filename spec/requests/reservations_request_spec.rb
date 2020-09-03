require 'rails_helper'

RSpec.describe "Reservations", type: :request do
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

  describe 'GET /users/reservations #index' do
    context 'valid' do
      before do
        get '/reservations',
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
      before { get '/reservations' }

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
        get "/reservations/#{reservation_id}",
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
      before { get "/reservations/#{reservation_id}" }

      it 'returns error message' do
        expect(json['error']).to eq('Please log in.')
      end

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end

    context 'invalid reservations index' do
      before do
        get "/reservations/#{reservation_id + 1}",
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

  describe 'POST /users/reservation #create' do
    let(:start_time_string) { DateTime.now.iso8601 }
    let(:end_time_string) { (DateTime.now + 2.hours).iso8601 }

    context 'valid' do
      before do
        params = {
          start_time: start_time_string,
          end_time: end_time_string,
          room_id: room_id
        }

        post "/reservations",
          params: params,
          headers: token_headers(user_token)
      end

      it 'creates a reservation for the user' do
        created_reservation = Reservation.last

        expect(created_reservation.user.id).to eq(user_id)
      end

      it 'saves room correctly' do
        created_reservation = Reservation.last

        expect(created_reservation.room.id).to eq(room_id)
      end

      it 'parses datetime correctly' do
        created_reservation = Reservation.last

        expect(created_reservation.start_time).to eq(start_time_string)
        expect(created_reservation.end_time).to eq(end_time_string)
      end

      it 'returns serialized reservation' do
        created_reservation = Reservation.last

        serialized_reservation = ReservationSerializer.new(created_reservation)
        stringified_reservation = serialized_reservation.to_h.deep_stringify_keys

        expect(json['reservation']).to eq(stringified_reservation)
      end

      it 'has status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'user not logged in' do
      before do
        params = {
          start_time: start_time_string,
          end_time: end_time_string,
          room_id: room_id
        }

        post "/reservations",
          params: params
      end

      it 'returns error message' do
        expect(json['error']).to eq('Please log in.')
      end

      it 'has status code 401' do
        expect(response).to have_http_status(401)
      end
    end

    context 'invalid request' do
      before do
        params = {
          start_time: start_time_string,
          end_time: end_time_string
        }

        post "/reservations",
          params: params,
          headers: token_headers(user_token)
      end

      it 'return error message' do
        expect(json['error']).to eq('Missing or invalid params')
      end

      it 'has status code 400' do
        expect(response).to have_http_status(400)
      end
    end
  end

  describe 'DELETE /users/reservation #destroy' do
    context 'valid' do
      before do
        delete "/reservations/#{reservation_id}",
               headers: token_headers(user_token)
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'user not logged in' do
      before { delete "/reservations/#{reservation_id}" }

      it 'returns error message' do
        expect(json['error']).to eq('Please log in.')
      end

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end

    context 'invalid reservation id' do
      before do
        delete "/reservations/#{reservation_id + 1}",
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
