# frozen_string_literal: true

module Disbursements
  # Calculator which calculate amount which will be payout into Merchant
  class OrderPayoutCalculator < BaseCalculator
    def initialize(amount:)
      @amount = amount
    end

    attr_reader :amount

    def calculate
      (amount - calculated_order_fee).round(2)
    end

    private

    def calculated_order_fee
      Disbursements::OrderFeeCalculator.new(amount: amount).calculate
    end
  end
end
