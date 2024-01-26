# frozen_string_literal: true

# Migration adding reference field into disbursements table
class AddReferenceFieldForDisbursmentTable < ActiveRecord::Migration[7.1]
  def change
    add_column :disbursements, :reference, :string
  end
end
