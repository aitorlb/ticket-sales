# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :tickets

  def locked_tickets
    tickets.unsold.locked
  end

  def as_json(*_args)
    super.except('created_at', 'updated_at', 'password_digest')
  end
end
