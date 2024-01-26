# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Disbursements::Generate, type: :service do
  subject { described_class.call }

  describe '#call' do
    context 'create disbursements for orders from last day' do
      let!(:merchant) { create(:merchant) }
      let!(:daily_orders) { create_list(:order, 10, :within_daily_range, merchant_id: merchant.id) }

      it 'create disbursement with order collection' do
        expect(merchant.disbursements.size).to eq 0
        subject
        expect(merchant.disbursements.reload.size).to eq 1
        expect(merchant.disbursements.first.orders.size).to eq 10
      end
    end

    context 'create disbursements with calculate minimum_month_fee' do
      let!(:merchant) { create(:merchant, minimum_monthly_fee: 50.50) }
      let!(:last_month_orders_disbursement) do
        create_list(:disbursement, 10, :within_monthly_range, commision_amount: 0.04, merchant_id: merchant.id)
      end
      let!(:daily_orders) { create_list(:order, 10, :within_daily_range, merchant_id: merchant.id) }

      it 'create disbursment with minimum_month_fee field' do
        expect { subject }.to change { Disbursement.all.size }.from(10).to(11)

        expect(merchant.disbursements.reload.pluck(:minimum_monthly_fee).sum).not_to eq 0.0
      end
    end
    context 'when no orders for merchant' do
      let!(:merchant) { create(:merchant) }

      it 'dont create noting' do
        res = subject
        expect(res.success).to eq true
      end
    end
  end
end
