# frozen_string_literal: true

module Disbursements
  module Order
    # Calculator which calculate amount which will be payout into Merchant
    class PayoutCalculator < BaseCalculator
      def initialize(amount:)
        @amount = amount
      end

      attr_reader :amount

      def calculate
        (amount - calculated_order_fee).round(2)
      end

      private

      def calculated_order_fee
        Disbursements::Order::FeeCalculator.new(amount: amount).calculate
      end
    end
  end
end
