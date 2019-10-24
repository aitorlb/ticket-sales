# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'user@example.org' }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
