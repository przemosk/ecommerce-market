# frozen_string_literal: true

# == Schema Information
#
# Table name: orders
#
#  id              :uuid             not null, primary key
#  amount          :decimal(10, 2)   default(0.0), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  disbursement_id :uuid
#  merchant_id     :uuid
#
# Indexes
#
#  index_orders_on_disbursement_id  (disbursement_id)
#  index_orders_on_merchant_id      (merchant_id)
#
# Foreign Keys
#
#  fk_rails_...  (disbursement_id => disbursements.id)
#  fk_rails_...  (merchant_id => merchants.id)
#
class Order < ApplicationRecord
  belongs_to :merchant
  belongs_to :disbursement, optional: true

  with_options presence: true do
    validates :amount, :merchant
  end

  def calculate_payout_amount
    Disbursements::OrderPayoutCalculator.new(amount: amount).calculate
  end

  def calculate_commision_fee
    Disbursements::OrderFeeCalculator.new(amount: amount).calculate
  end
end
