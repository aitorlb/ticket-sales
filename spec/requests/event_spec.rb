# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Events API', type: :request do
  let!(:user) { create(:user) }
  let!(:events) { create_list(:event_with_tickets, 3, tickets_count: 10) }
  let(:event_id) { Event.first.id }

  describe 'GET /events' do
    before { get_resource('events') }

    it 'returns an array of events' do
      expect(json_response).not_to be_empty
      expect(json_response.size).to eq(3)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /events/:id' do
    before { get_resource("events/#{event_id}") }

    context 'when the event exists' do
      it 'returns the event' do
        expect(json_response).not_to be_empty
        expect(json_response['id']).to eq(event_id)
        expect(json_response['name']).to be_present
        expect(json_response['date']).to be_present
      end

      it 'returns the event' do
        expect(json_response).not_to be_empty
        expect(json_response['id']).to eq(event_id)
      end

      it 'returns what quantity of tickets is available.' do
        expect(json_response['available_tickets']).to eq(10)
      end
    end

    context 'when the record does not exist' do
      let(:event_id) { 99 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Event/)
      end
    end
  end
end
