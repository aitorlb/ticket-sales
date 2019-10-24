# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Purchases API', type: :request do
  let!(:user) { create(:user) }
  let!(:event) { create(:event, tickets: tickets) }
  let(:tickets) { [ticket] }
  let(:ticket) { create(:ticket) }

  before do
    authenticate(email: user.email, password: user.password)
  end

  describe 'PUT /events/:id/purchases' do
    before do
      put_with_token("events/#{event.id}/purchases", ticket_count: 1)
    end

    context 'when the tickets are available' do
      it 'returns an array of tickets locked for the user' do
        expect(json_response).not_to be_empty
        expect(json_response.size).to eq(1)
        expect(json_response.sample['locked_until']).to be_present
        expect(json_response.sample['user_id']).to eq(user.id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the tickets are NOT available' do
      let(:tickets) { [] }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns an error message' do
        expect(response.body).to match(/Tickets no longer available/)
      end
    end
  end

  describe 'POST /events/:id/purchases' do
    let(:params) { { ticket_count: 1, payment_token: payment_token } }
    let(:payment_token) { 'success' }

    before do
      post_with_token("events/#{event.id}/purchases", params)
    end

    context 'when the tickets are available' do
      it 'returns a purchase' do
        expect(json_response).not_to be_empty
        expect(json_response['amount']).to eq(ticket.price)
        expect(json_response['currency']).to eq('EUR')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the tickets are NOT available' do
      let(:tickets) { [] }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns an error message' do
        expect(response.body).to match(/Tickets no longer available/)
      end
    end

    context 'when payment_token is invalid (payment error)' do
      let(:payment_token) { 'payment_error' }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns an error message' do
        expect(response.body).to match(/Something went wrong with your transaction/)
      end
    end

    context 'when payment_token is invalid (card error)' do
      let(:payment_token) { 'card_error' }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns an error message' do
        expect(response.body).to match(/Your card has been declined/)
      end
    end
  end
end
