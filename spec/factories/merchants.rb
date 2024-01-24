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
FactoryBot.define do
  factory :merchant do
    name { FFaker::Name.name }
    email { FFaker::Internet.email }
    live_on { Date.today.ago(3600 * 24) }
    disbursement_frequency { 0 }
    minimum_monthly_fee { FFaker::Number.decimal }
  end
end
