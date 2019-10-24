# frozen_string_literal: true

class PurchaseMaker
  # put SimpleCommand before the class' ancestors chain
  prepend SimpleCommand

  # optional, initialize the command with some arguments
  def initialize(checkout_cart:, payment_token:)
    @checkout_cart = checkout_cart
    @payment_token = payment_token
  end

  # mandatory: define a #call method. its return value will be available
  #            through #result
  def call
    Ticket.transaction do
      unless @checkout_cart.tickets_available?
        return errors.add(:tickets, 'Tickets no longer available') && nil
      end

      result = charge
      purchase_tickets
      create_purchase(result)
    rescue StandardError => e
      errors.add(:payment_token, e.message)
      nil
    end
  end

  private

  def charge
    raise 'Missing payment token' unless @payment_token

    Payment::Gateway.charge(
      amount: @checkout_cart.total_price,
      token: @payment_token
    )
  end

  def purchase_tickets
    @checkout_cart.tickets.each { |ticket| ticket.purchase!(@checkout_cart.user) }
  end

  def create_purchase(result)
    params = result.as_json.merge(
      tickets: @checkout_cart.tickets,
      user: @checkout_cart.user
    )
    Purchase.create!(params)
  end
end
