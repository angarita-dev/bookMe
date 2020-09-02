require 'rails_helper'

RSpec.describe 'Rooms', type: :request do
  let!(:room_list) { create_list(:room, 5) }
  let(:first_room_id) { room_list.first }
  let(:first_room_id) { room_list.first.id }
  let(:not_existing_id) { room_list.last.id + 1 }

  describe 'GET /rooms #index' do
    before { get '/rooms' }

    it 'returns rooms list' do
      expect(json).to_not be_empty
      expect(json.size).to eq(room_list.count)
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
end
