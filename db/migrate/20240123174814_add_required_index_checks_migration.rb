# frozen_string_literal: true

# Refactoring tables columns
class AddRequiredIndexChecksMigration < ActiveRecord::Migration[7.1]
  def change
    remove_column :merchants, :minimum_monthly_fee, :decimal
    remove_column :orders, :amount, :decimal

    add_column :merchants, :minimum_monthly_fee, :decimal, precision: 10, scale: 2, default: 0.0, null: false
    add_column :orders, :amount, :decimal, precision: 10, scale: 2, default: 0.0, null: false
  end
end
