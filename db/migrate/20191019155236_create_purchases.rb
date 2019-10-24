# frozen_string_literal: true

class CreatePurchases < ActiveRecord::Migration[5.2]
  def change
    create_table :purchases do |t|
      t.integer :amount
      t.string :currency

      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
