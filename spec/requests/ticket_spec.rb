# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tickets API', type: :request do
  let!(:user) { create(:user) }
  let!(:event) { create(:event) }
  let!(:tickets) { create_list(:ticket, 3, event: event) }

  describe 'GET /events/:event_id/tickets' do
    before { get_resource("events/#{event.id}/tickets") }

    it 'returns an array of (available) tickets' do
      expect(json_response).not_to be_empty
      expect(json_response.size).to eq(3)
      expect(json_response.sample['price']).to be_present
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end
end
