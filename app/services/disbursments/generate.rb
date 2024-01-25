# frozen_string_literal: true

module Disbursments
  # ServiceObject for creating daily Disbursements
  # Based on Merchant with daily and weekly ( matched to today weekday )
  class Generate
    prepend ::ServiceModule::Base

    def call
      Merchant.with_daily_or_weekly_payouts.find_each do |merchant|
        ActiveRecord::Base.transaction do
          disbursement = merchant.disbursements.create!

          disbursement.calculate_minimum_monthly_fee if merchant.first_disbursement_in_current_month?

          if merchant.daily?
            merchant.orders_for_daily_disbursement_collection.find_each do |order|
              disbursement.add_order(order: order)
            end
          elsif merchant.weekly?
            merchant.orders_for_weekly_disbursement_collection.find_each do |order|
              disbursement.add_order(order: order)
            end
          end
        end
      end
    end
  end
end
