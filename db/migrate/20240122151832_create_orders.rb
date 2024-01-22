# frozen_string_literal: true

# Create table 'orders'
class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders, id: :uuid do |t|
      t.decimal :amount, precision: 8, scale: 2, default: 0.0

      t.references :merchant, foreign_key: true, index: true, type: :uuid

      t.timestamps
    end
  end
end
