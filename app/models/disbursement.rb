# frozen_string_literal: true

# == Schema Information
#
# Table name: disbursements
#
#  id                  :uuid             not null, primary key
#  commision_amount    :decimal(10, 2)   default(0.0), not null
#  minimum_monthly_fee :decimal(10, 2)   default(0.0), not null
#  reference           :string
#  total_amount        :decimal(10, 2)   default(0.0), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  merchant_id         :uuid
#
# Indexes
#
#  index_disbursements_on_merchant_id  (merchant_id)
#
# Foreign Keys
#
#  fk_rails_...  (merchant_id => merchants.id)
#
class Disbursement < ApplicationRecord
  belongs_to :merchant, inverse_of: :disbursements
  has_many :orders, inverse_of: :disbursement, dependent: :nullify

  after_initialize :generate_reference_number

  with_options presence: true do
    validates :merchant, :reference
  end

  def add_order(order:)
    calculate_financial_obligation(order: order)

    order.update_attribute!(:disbursement_id, id)
  end

  def calculate_minimum_monthly_fee
    fee_value = Disbursements::MinimumMonthlyFeeCalculator.new(
      min_monthly_merchant_fee: merchant.minimum_monthly_fee,
      last_month_merchant_fees: merchant.calculate_last_month_disbursement_fee
    ).calculate

    update_attribute!(:minimum_monthly_fee, fee_value)
  end

  def calculate_financial_obligation(order:)
    transaction do
      calculate_commision_fee(order_amount: order.calculate_commision_fee)
      calculate_total_amount(order_amount: order.calculate_payout_amount)
    end
  end

  private

  def generate_reference_number
    self.reference ||= SecureRandom.hex(6)
  end

  def calculate_total_amount(order_amount:)
    increment!(:total_amount, order_amount)
  end

  def calculate_commision_fee(order_amount:)
    increment!(:commision_amount, order_amount)
  end
end
