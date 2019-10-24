# frozen_string_literal: true

FactoryBot.define do
  factory :ticket do
    price { 10 }
    sold { false }
    event
  end
end
