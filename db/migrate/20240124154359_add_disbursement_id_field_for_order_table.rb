# frozen_string_literal: true

# Add disbursement_id field into orders table
class AddDisbursementIdFieldForOrderTable < ActiveRecord::Migration[7.1]
  def change
    add_reference :orders, :disbursement, foreign_key: true, index: true, type: :uuid
  end
end
