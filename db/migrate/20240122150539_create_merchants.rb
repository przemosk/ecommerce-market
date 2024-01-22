# frozen_string_literal: true

# Creating table 'merchants'
class CreateMerchants < ActiveRecord::Migration[7.1]
  def change
    create_table :merchants, id: :uuid do |t|
      t.datetime :live_on
      t.decimal :minimum_monthly_fee, precision: 8, scale: 2, default: 0.0

      t.integer :disbursement_frequency

      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
