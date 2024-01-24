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
require 'rails_helper'

Rails.describe Order, type: :model do
  let!(:merch) { create(:merchant) }
  let!(:order) { create(:order, merchant: merch) }

  describe '#calculate_commision_fee' do
    context 'when amount smaller than 50' do
      before { order.update_attribute(:amount, 48.88) }

      it 'return result multipled by 0.01' do
        result = order.calculate_commision_fee

        expect(result).to eq (order.amount * 0.01).round(2)
      end
    end

    context 'when amount is between 50 and 300' do
      before { order.update_attribute(:amount, 150.00) }

      it 'return result multipled by 0.0095' do
        result = order.calculate_commision_fee

        expect(result).to eq (order.amount * 0.0095).round(2)
      end
    end

    context 'when bigger than 300' do
      before { order.update_attribute(:amount, 420.00) }

      it 'return result multipled by 0.0085' do
        result = order.calculate_commision_fee

        expect(result).to eq (order.amount * 0.0085).round(2)
      end
    end
  end
end
