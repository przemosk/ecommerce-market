# frozen_string_literal: true

# == Schema Information
#
# Table name: disbursements
#
#  id               :uuid             not null, primary key
#  commision_amount :decimal(10, 2)   default(0.0), not null
#  total_amount     :decimal(10, 2)   default(0.0), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  merchant_id      :uuid
#
# Indexes
#
#  index_disbursements_on_merchant_id  (merchant_id)
#
# Foreign Keys
#
#  fk_rails_...  (merchant_id => merchants.id)
#
class Disbursement < ApplicationRecord
  belongs_to :merchant
  has_many :orders
end
