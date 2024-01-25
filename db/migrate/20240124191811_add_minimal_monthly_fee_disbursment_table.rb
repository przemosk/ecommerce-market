# frozen_string_literal: true

# Add field minimum_monthly_fee to disbursements table
class AddMinimalMonthlyFeeDisbursmentTable < ActiveRecord::Migration[7.1]
  def change
    add_column :disbursements, :minimum_monthly_fee, :decimal, precision: 10, scale: 2, default: 0.0, null: false
  end
end
