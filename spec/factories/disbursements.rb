# frozen_string_literal: true

FactoryBot.define do
  factory :disbursement do
    merchant { create(:merchant) }
    total_amount { 0.0 }
    commision_amount { 0 }

    trait :within_monthly_range do
      created_at { rand(Date.current.last_month.beginning_of_month..Date.current.last_month.beginning_of_month) }
    end

    trait :within_weekly_range do
      created_at { rand(Date.current.ago(3600 * (24 * 8)).beginning_of_day..Date.current.ago(3600 * 24).end_of_day) }
    end

    trait :within_daily_range do
      created_at { rand(Date.current.ago(3600 * 24).beginning_of_day..Date.current.ago(3600 * 24).end_of_day) }
    end
  end
end
