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
FactoryBot.define do
  factory :order do
    amount { FFaker::Number.decimal }
  end

  trait :within_monthly_range do
    created_at { Date.current.last_month.beginning_of_month..Date.current.last_month.end_of_month }
  end

  trait :withing_daily_range do
    created_at { rand(Date.current.ago(3600 * 24).beginning_of_day..Date.current.ago(3600 * 24).end_of_day) }
  end

  trait :withing_weekly_range do
    created_at { rand(Date.current.ago(3600 * (24 * 8)).beginning_of_day..Date.current.ago(3600 * 24).end_of_day) }
  end
end
