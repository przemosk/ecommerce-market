# frozen_string_literal: true

module Disbursements
  # Calculator which calculate commision amount based on Order amount
  class OrderFeeCalculator < BaseCalculator
    def initialize(amount:)
      @amount = amount
    end

    attr_reader :amount

    def calculate
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
end
