# frozen_string_literal: true

class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.integer :price
      t.datetime :locked_until
      t.boolean :sold, default: false

      t.references :user, foreign_key: true
      t.references :event, foreign_key: true
      t.references :purchase, foreign_key: true

      t.timestamps
    end
  end
end
