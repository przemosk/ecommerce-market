# frozen_string_literal: true

# Create 'disbursements' table
class CreateDisbursements < ActiveRecord::Migration[7.1]
  def change
    create_table :disbursements, id: :uuid do |t|
      t.references :merchant, foreign_key: true, index: true, type: :uuid

      t.decimal :total_amount, precision: 10, scale: 2, default: 0.0, null: false
      t.decimal :commision_amount, precision: 10, scale: 2, default: 0.0, null: false


      t.timestamps
    end
  end
end
