# frozen_string_literal: true

class Ticket < ApplicationRecord
  belongs_to :event
  belongs_to :user, optional: true

  scope :unsold, -> { where(sold: false) }
  scope :locked, -> { where(arel_table[:locked_until].gt(Time.now)) }

  validates_presence_of :user, if: :locked_until?

  TicketPurchaseError = Class.new(StandardError)

  def locked_by?(user)
    user.locked_tickets.include?(self)
  end

  def lock_for(user, time = 10.minutes.from_now)
    return nil if locked_by?(user)

    update(locked_until: time, user: user)
  end

  def unlock
    update(locked_until: nil, user: nil)
  end

  def purchase!(user)
    raise TicketPurchaseError, 'Ticket sold!' if sold?
    raise TicketPurchaseError, 'Ticket locked!' unless locked_by?(user)

    update!(sold: true, locked_until: nil)
  end

  def as_json(*_args)
    super.except('created_at', 'updated_at')
  end
end
