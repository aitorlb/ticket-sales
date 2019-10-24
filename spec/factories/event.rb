# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    date { 1.week.from_now }
    sequence(:name) { |n| "Event_#{n}" }

    factory :event_with_tickets do
      transient do
        tickets_count { 5 }
      end

      after(:create) do |event, evaluator|
        create_list(:ticket, evaluator.tickets_count, event: event)
      end
    end
  end
end
