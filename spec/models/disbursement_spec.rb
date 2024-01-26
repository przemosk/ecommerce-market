# frozen_string_literal: true

# == Schema Information
#
# Table name: disbursements
#
#  id                  :uuid             not null, primary key
#  commision_amount    :decimal(10, 2)   default(0.0), not null
#  minimum_monthly_fee :decimal(10, 2)   default(0.0), not null
#  reference           :string
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
require 'rails_helper'

Rails.describe Disbursement, type: :model do
  describe '#generate_reference_number' do
    context 'after instanace initialization' do
      it 'generate reference number' do
        res = described_class.new
        expect(res.reference).to be_present
      end
    end
  end

  describe '#add_order' do
    let!(:merchant) { create(:merchant) }
    let!(:disbursement) { create(:disbursement, merchant: merchant) }
    let!(:order) { create(:order, disbursement_id: nil, merchant_id: merchant.id) }

    before { allow(disbursement).to receive(:calculate_financial_obligation) }

    it 'call calculate_financial_obligation for order' do
      expect(disbursement).to receive(:calculate_financial_obligation).with(order: order)
      disbursement.add_order(order: order)
    end

    it 'add order to the disbursement' do
      expect { disbursement.add_order(order: order) }
        .to change { disbursement.orders.count }
        .by(1)
    end

    it 'updates the order with the disbursement id' do
      expect { disbursement.add_order(order: order) }
        .to change { order.reload.disbursement_id }
        .from(nil)
        .to(disbursement.id)
    end
  end

  describe '#calculate_minimum_monthly_fee' do
    let!(:merchant) { create(:merchant, minimum_monthly_fee: 10.00) }
    let!(:last_disbursements) { create_list(:disbursement, 10, :within_monthly_range, commision_amount: 0.05, merchant_id: merchant.id) }
    let!(:disbursement) { create(:disbursement, merchant_id: merchant.id) }

    it 'persist calculated value' do
      calculated_fee = merchant.minimum_monthly_fee - last_disbursements.pluck(:commision_amount).sum.round(2)

      expect { disbursement.calculate_minimum_monthly_fee }
        .to change { disbursement.minimum_monthly_fee }
        .by(calculated_fee)
    end
  end

  describe '#calculate_financial_obligation' do
    let!(:merchant) { create(:merchant) }
    let!(:order) { create(:order, merchant_id: merchant.id) }
    let!(:disbursement) { create(:disbursement, merchant_id: merchant.id) }

    context 'persist calculated with Disbursement instnace' do
      it 'change commission fee column value' do
        allow(order).to receive(:calculate_commision_fee).and_return(2.00)
        allow(order).to receive(:calculate_payout_amount).and_return(8.00)

        expect { disbursement.calculate_financial_obligation(order: order) }
          .to change { disbursement.commision_amount }
          .by(2)
          .and change { disbursement.total_amount }
          .by(8)
      end
    end
  end
end
