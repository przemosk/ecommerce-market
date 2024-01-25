# frozen_string_literal: true

# == Schema Information
#
# Table name: disbursements
#
#  id                  :uuid             not null, primary key
#  commision_amount    :decimal(10, 2)   default(0.0), not null
#  minimum_monthly_fee :decimal(10, 2)   default(0.0), not null
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
FactoryBot.define do
  factory :disbursement do
    merchant { create(:merchant) }
    total_amount { 0.0 }
    commision_amount { 0 }

    trait :within_monthly_range do
      created_at { rand(Date.current.last_month.beginning_of_month..Date.current.last_month.end_of_month) }
    end

    trait :within_weekly_range do
      created_at { rand(Date.current.ago(3600 * (24 * 8)).beginning_of_day..Date.current.ago(3600 * 24).end_of_day) }
    end

    trait :within_daily_range do
      created_at { rand(Date.current.ago(3600 * 24).beginning_of_day..Date.current.ago(3600 * 24).end_of_day) }
    end
  end
end
