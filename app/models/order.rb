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
    amount - calculate_commision_fee
  end

  # move to separate calculator ?
  def calculate_commision_fee
    total = if amount < 50
              amount * 0.01
            elsif (50...300).member?(amount)
              amount * 0.0095
            else
              amount * 0.0085
            end

    total.round(2)
  end
end
