# frozen_string_literal: true

# == Schema Information
#
# Table name: merchants
#
#  id                     :uuid             not null, primary key
#  disbursement_frequency :integer
#  email                  :string
#  live_on                :datetime
#  minimum_monthly_fee    :decimal(8, 2)    default(0.0)
#  name                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class Merchant < ApplicationRecord
  enum disbursement_frequency: { daily: 0, weekly: 1 }

  has_many :orders
  has_many :disbursements

  with_options presence: true do
    validate :name, :email, :disbursement_frequency
  end
end
