# frozen_string_literal: true

# == Schema Information
#
# Table name: orders
#
#  id          :uuid             not null, primary key
#  amount      :decimal(8, 2)    default(0.0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  merchant_id :uuid
#
# Indexes
#
#  index_orders_on_merchant_id  (merchant_id)
class Order < ApplicationRecord
  belongs_to :merchant

  # TODO: add some validation
  with_options presence: true do
    validate :amount, :merchant
  end
end
