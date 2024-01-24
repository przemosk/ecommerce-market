# frozen_string_literal: true

# == Schema Information
#
# Table name: merchants
#
#  id                     :uuid             not null, primary key
#  disbursement_frequency :integer
#  email                  :string
#  live_on                :datetime
#  minimum_monthly_fee    :decimal(10, 2)   default(0.0), not null
#  name                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class Merchant < ApplicationRecord
  enum disbursement_frequency: { daily: 0, weekly: 1 }

  has_many :orders
  has_many :disbursements

  scope :with_daily_payouts, -> { where(disbursement_frequency: 0) }
  scope :with_weekly_payouts, -> { where(disbursement_frequency: 1).where('EXTRACT(DOW FROM live_on) = ?', Date.current.wday) }

  def calculate_last_month_disbursement_fee
    disbursements
      .where(disbursements: { created_at: DateTime.current.last_month.beginning_of_month..DateTime.current.last_month.end_of_month })
      .pluck(:commision_amount)
      .compact
      .sum
      .round(2)
  end

  def first_disbursement_in_current_month?
    disbursements.where(created_at: DateTime.current.beginning_of_month..DateTime.current).empty?
  end

  # here is assumption that we exclude current day (thats the reason of ), because we targeting for orders from day before we execute flow
  def orders_for_daily_disbursement_collection
    orders
      .where(disbursement_id: nil)
      .where(created_at: Date.current.ago(3600 * 24).beginning_of_day..Date.current.ago(3600 * 24).end_of_day)
  end

  # here is assumption that we exclude current day (thats the reason of 8), because we targeting for orders from day before we execute flow
  def orders_for_weekly_disbursement_collection
    orders
      .where(disbursement_id: nil)
      .where(created_at: Date.current.ago(3600 * (24 * 8)).beginning_of_day..Date.current.ago(3600 * 24).end_of_day)
  end
end
