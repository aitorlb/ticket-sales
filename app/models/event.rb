# frozen_string_literal: true

class Event < ApplicationRecord
  has_many :tickets, dependent: :destroy

  validates_presence_of :name, :date

  def unsold_tickets
    tickets.unsold
  end

  def locked_tickets
    unsold_tickets.locked
  end

  def available_tickets?
    available_tickets.positive?
  end

  def available_tickets
    unsold_tickets - locked_tickets
  end

  def take_available_tickets(count)
    available_tickets.take(count)
  end

  def date
    super.strftime('%d/%m/%Y %H:%M %Z')
  end

  def as_json(*_args)
    super.except('created_at', 'updated_at').tap do |hsh|
      hsh['available_tickets'] = available_tickets.count
    end
  end
end
