# frozen_string_literal: true

class CheckoutCart
  def initialize(tickets, user)
    @tickets = tickets
    @user = user
  end

  attr_reader :user, :tickets

  def tickets_available?
    @tickets.all? { |ticket| @user.locked_tickets.include?(ticket) }
  end

  def total_price
    @tickets.map(&:price).sum
  end
end
