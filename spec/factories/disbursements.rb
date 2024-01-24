# frozen_string_literal: true

FactoryBot.define do
  factory :disbursement do
    merchant { create(:merchant) }
    total_amount { 0.0 }
    commision_amount { 0 }
  end
end
