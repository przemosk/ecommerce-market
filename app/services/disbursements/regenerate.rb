# frozen_string_literal: true

module Disbursements
  # ServiceObject for creating Disbursements
  # Based on Orders with disbursement_id: nil
  class Regenerate
    prepend ::ServiceModule::Base

    def call
      orders_grouped_by_date = ::Order.includes(:merchant).where(disbursement_id: nil).group_by(&:created_at)
      unique_dates_sorted = orders_grouped_by_date.keys.sort

      unique_dates_sorted.map do |date|
        merchant_ids = orders_grouped_by_date[date].pluck(:merchant_id).uniq
        merchants = Merchant.where(id: merchant_ids).index_by(&:id)

        orders_grouped_by_date[date].each do |order|
          merchant = merchants[order.merchant_id]
          disbursement = merchant.disbursements.find_or_create_by!(created_at: date)

          disbursement.add_order(order: order)

          if merchant.disbursements.where(created_at: date.to_date.beginning_of_month..Date.current).size == 1
            disbursement.calculate_minimum_monthly_fee
          end
        end
      end
    end
  end
end
