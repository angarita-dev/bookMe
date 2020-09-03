require 'rails_helper'

RSpec.describe 'Rooms', type: :request do
  let!(:room_list) { create_list(:room, 5) }

  let(:first_room_id) { room_list.first }
  let(:first_room_id) { room_list.first.id }
  let(:not_existing_id) { Room.last.id + 1 }

  let(:user_password) { 'S3cuR3_p4Ssw0rD' }

  let!(:user) { create(:user, email: user_email, password: user_password) }
  let(:user_email) { Faker::Internet.unique.email }
  let!(:user_token) { login(user_email, user_password) }

  let!(:admin) { create(:admin, email: admin_email, password: user_password) }
  let(:admin_email) { Faker::Internet.unique.email }
  let!(:admin_token) { login(admin_email, user_password) }

  let!(:room) { create(:room) }
  let(:room_id) { room.id }

  describe 'GET /rooms #index' do
    before { get '/rooms' }

    it 'returns rooms list' do
      expect(json).to_not be_empty
      expect(json.size).to eq(Room.count)
    end

    it 'returns 200 code' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /rooms/:id #show' do
    context 'valid request' do
      before { get "/rooms/#{first_room_id}" }

      it 'returns room info' do
        expect(json['id']).to eq(first_room_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'invaid request' do
      before { get "/rooms/#{not_existing_id}" }

      it 'returns error message' do
        expect(json['error']).to eq('Wrong room id')
      end

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end
    end
  end

  describe 'PUT /admin/rooms/:id #update' do
    context 'normal user' do
      before do
        params = {
          img_url: Faker::Internet.url
        }

        put "/admin/rooms/#{room_id}",
            params: params,
            headers: token_headers(user_token)
      end

      it 'returns error message' do
        expect(json['error']).to eq('Admin only action')
      end

      it 'returns http status 401' do
        expect(response).to have_http_status(401)
      end
    end

    context 'admin user valid id' do
      before do
        params = {
          img_url: Faker::Internet.url
        }

        put "/admin/rooms/#{room_id}",
            params: params,
            headers: token_headers(admin_token)
      end

      it 'updates room' do
        room.reload

        serialized_room = RoomSerializer.new(room)
        parsed_serialized_room = serialized_room.to_h.deep_stringify_keys

        expect(json['room']).to eq(parsed_serialized_room)
      end

      it 'has 200 code' do
        expect(response).to have_http_status(200)
      end
    end

    context 'admin user invalid id' do
      before do
        delete "/admin/rooms/#{room_id + 1}",
               headers: token_headers(admin_token)
      end

      it 'returns error message' do
        expect(json['error']).to eq('Wrong room id')
      end

      it 'has 400 code' do
        expect(response).to have_http_status(400)
      end
    end
  end

  describe 'DELETE /admin/rooms/:id #destroy' do
    context 'normal user' do
      before do
        delete "/admin/rooms/#{room_id}",
               headers: token_headers(user_token)
      end

      it 'returns error message' do
        expect(json['error']).to eq('Admin only action')
      end

      it 'returns http status 401' do
        expect(response).to have_http_status(401)
      end
    end

    context 'admin user' do
      context 'valid id' do
        before do
          delete "/admin/rooms/#{room_id}",
                 headers: token_headers(admin_token)
        end

        it 'deletes room' do
          room_query_result = Room.where(id: room_id)

          expect(room_query_result.empty?).to eq(true)
        end

        it 'returns deleted room' do
          serialized_room = RoomSerializer.new(room)
          parsed_serialized_room = serialized_room.to_h.deep_stringify_keys

          expect(json['room']).to eq(parsed_serialized_room)
        end

        it 'has 200 code' do
          expect(response).to have_http_status(200)
        end
      end

      context 'invalid id' do
        before do
          delete "/admin/rooms/#{room_id + 1}",
                 headers: token_headers(admin_token)
        end

        it 'returns error message' do
          expect(json['error']).to eq('Wrong room id')
        end

        it 'has 400 code' do
          expect(response).to have_http_status(400)
        end
      end
    end
  end
end
