# frozen_string_literal: true

module Disbursements
  # Calculator which combine Merchant minimal_monthly_value
  # with his commision sum from previous month
  class MinimumMonthlyFeeCalculator < BaseCalculator
    def initialize(min_monthly_merchant_fee:, last_month_merchant_fees:)
      @min_monthly_merchant_fee = min_monthly_merchant_fee
      @last_month_merchant_fees = last_month_merchant_fees
    end

    attr_reader :min_monthly_merchant_fee, :last_month_merchant_fees

    def calculate
      return (min_monthly_merchant_fee - last_month_merchant_fees) if min_monthly_merchant_fee > last_month_merchant_fees
      return 0.00 if last_month_merchant_fees > min_monthly_merchant_fee

      0.00
    end
  end
end
