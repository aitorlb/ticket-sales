# frozen_string_literal: true

class Purchase < ApplicationRecord
  belongs_to :user
  has_many :tickets

  def as_json(*_args)
    super.except('updated_at', 'user_id').tap do |hsh|
      hsh['user'] = user
      hsh['tickets'] = tickets
    end
  end
end
