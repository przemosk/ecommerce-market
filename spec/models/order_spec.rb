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
  let!(:order) { create(:order, merchant: merch, amount: 100.00) }

  describe '#calculate_commision_fee' do
    context 'call Disbursements::OrderFeeCalculator' do
      it 'with correct amount' do
        allow(Disbursements::OrderFeeCalculator)
          .to receive(:new)
          .with(amount: 100.00)
          .and_return(double('OrderFeeCalculator', calculate: 10.00))

        result = order.calculate_commision_fee
        expect(result).to eq 10.00
      end
    end
  end

  describe '#calculate_payout_amount' do
    context 'call Disbursements::OrderPayoutCalculator' do
      it 'with correct amount' do
        allow(Disbursements::OrderPayoutCalculator)
          .to receive(:new)
          .with(amount: 100.00)
          .and_return(double('OrderPayoutCalculator', calculate: 10.00))

        result = order.calculate_payout_amount
        expect(result).to eq 10.00
      end
    end
  end
end
