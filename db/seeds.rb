# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(email: 'user@example.com', password: 'password', password_confirmation: 'password')

5.times do |n|
  event = Event.create(name: "Event ##{n + 1}", date: n.days.from_now)
  10.times { event.tickets.create(price: 10) }
end
