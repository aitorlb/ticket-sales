# frozen_string_literal: true

require 'rails_helper'

describe PurchaseMaker do
  let(:user) { create(:user) }
  let(:ticket) { create(:ticket, locked_until: 5.minutes.from_now, user: user) }
  let(:checkout_cart) { CheckoutCart.new([ticket], user) }
  let(:token) { 'success' }
  let(:command) { described_class.new(checkout_cart: checkout_cart, payment_token: token) }

  describe 'happy path' do
    let(:purchase) { Purchase.last }

    it 'succeeds' do
      expect(command.call).to be_success
    end

    it 'creates a purchase' do
      expect { command.call }.to change { Purchase.count }.by(1)
      expect(purchase.user).to eq(user)
      expect(purchase.currency).to eq('EUR')
      expect(purchase.amount).to eq(ticket.price)
      expect(purchase.tickets).to eq([ticket])
    end

    it 'updates the state of the tickets' do
      expect { command.call }.to change(ticket, :sold)
    end
  end

  describe 'fails if tickets are already sold' do
    let(:ticket) { create(:ticket, sold: true, user: user) }

    it 'fails' do
      expect(command.call).not_to be_success
      expect(command.call.errors.as_json).to include('tickets' => 'Tickets no longer available')
    end

    it 'does not create a purchase' do
      expect { command.call }.not_to change(ticket, :sold)
    end
  end

  describe 'fails if tickets are no longer locked for the user' do
    let(:ticket) { create(:ticket, locked_until: 1.second.ago, user: user) }

    it 'fails' do
      expect(command.call).not_to be_success
      expect(command.call.errors.as_json).to include('tickets' => 'Tickets no longer available')
    end

    it 'does not create a purchase' do
      expect { command.call }.not_to change(ticket, :sold)
    end

    it 'does not update the state of the tickets' do
      expect { command.call }.not_to change(ticket, :sold)
    end
  end

  describe 'fails if payment_token is invalid (card error)' do
    let(:token) { 'card_error' }

    it 'fails' do
      expect(command.call).not_to be_success
      expect(command.call.errors.as_json).to include('payment_token' => 'Your card has been declined.')
    end

    it 'does not create a purchase' do
      expect { command.call }.not_to change { Purchase.count }
    end

    it 'does not update the state of the tickets' do
      expect { command.call }.not_to change(ticket, :sold)
    end
  end

  describe 'fails if payment_token is invalid (payment error)' do
    let(:token) { 'payment_error' }

    it 'fails' do
      expect(command.call).not_to be_success
      expect(command.call.errors.as_json).to include('payment_token' => 'Something went wrong with your transaction.')
    end

    it 'does not create a purchase' do
      expect { command.call }.not_to change { Purchase.count }
    end

    it 'does not update the state of the tickets' do
      expect { command.call }.not_to change(ticket, :sold)
    end
  end
end
