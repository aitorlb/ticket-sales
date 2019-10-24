# frozen_string_literal: true

class TicketLocker
  # put SimpleCommand before the class' ancestors chain
  prepend SimpleCommand

  # optional, initialize the command with some arguments
  def initialize(event_id:, ticket_count:, user:)
    @event_id = event_id
    @count = ticket_count.to_i
    @user = user
  end

  # mandatory: define a #call method. its return value will be available
  #            through #result
  def call
    Ticket.transaction do
      if tickets_available?
        lock_tickets
        release_locked_tickets_excess
        tickets
      else
        errors.add(:tickets, 'Tickets no longer available')
        nil
      end
    end
  end

  private

  def tickets_available?
    tickets.size == @count
  end

  def lock_tickets
    return if tickets.all? { |ticket| locked_tickets.include?(ticket) }

    tickets.each { |ticket| ticket.lock_for(@user) }
  end

  def release_locked_tickets_excess
    (locked_tickets - tickets).each(&:unlock)
  end

  def tickets
    @tickets ||= locked_tickets.take(@count).presence || event.take_available_tickets(@count)
  end

  def locked_tickets
    @locked_tickets ||= @user.locked_tickets
  end

  def event
    @event ||= Event.find(@event_id)
  end
end
