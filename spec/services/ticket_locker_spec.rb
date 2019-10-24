# frozen_string_literal: true

require 'rails_helper'

describe TicketLocker do
  let!(:user) { create(:user) }
  let!(:event) { create(:event) }
  let!(:tickets) { create_list(:ticket, 2, event: event) }
  let(:command) { described_class.new(event_id: event.id, ticket_count: 1, user: user) }

  describe 'happy path' do
    it 'succeeds' do
      expect(command.call).to be_success
    end

    it 'locks the tickets for a user' do
      expect { command.call }.to change { user.locked_tickets.size }.from(0).to(1)
      # successive calls do not lock additional tickets
      expect { command.call }.not_to change { user.locked_tickets.reload.size }
    end

    it 'reduces the available tickets for a event' do
      expect { command.call }.to change { event.available_tickets.size }.from(2).to(1)
      # successive calls do reduce available tickets
      expect { command.call }.not_to change { event.available_tickets.size }
    end
  end

  describe 'fails if there are no available tickets' do
    before do
      tickets.each { |t| t.lock_for(create(:user)) }
    end

    it 'fails' do
      expect(command.call).not_to be_success
      expect(command.call.errors.as_json).to include('tickets' => 'Tickets no longer available')
    end

    it 'does not lock the tickets for a user' do
      expect { command.call }.not_to change { user.locked_tickets.reload.size }
    end

    it 'does not reduce the available tickets for a event' do
      expect { command.call }.not_to change { event.available_tickets.size }
    end
  end
end
