# frozen_string_literal: true

require 'rails_helper'

Rails.describe Disbursement, type: :model do
  subject { described_class }

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
