# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Disbursements::Regenerate, type: :service do
  subject { described_class.call }

  describe '#call' do
    context 'with last month orders present' do
      context 'with current month orders present' do
        let!(:merchant) { create(:merchant, minimum_monthly_fee: 100.00) }
        let!(:disbursement) { create(:disbursement, merchant_id: merchant.id) }
        let!(:previous_month_orders_with_disbursements) do
          create_list(:order, 20, :within_previous_month_range, amount: 5.00, merchant_id: merchant.id, disbursement_id: disbursement.id)
        end
        let!(:add_orders) do
          previous_month_orders_with_disbursements.each do |order|
            disbursement.add_order(order: order)
          end
        end
        let!(:current_month_orders_without_disbursement) do
          create_list(:order, 15, :with_current_month_range, merchant_id: merchant.id, disbursement_id: nil)
        end
        let(:current_month_disb) { merchant.disbursements.where(created_at: Date.current.beginning_of_month..Date.current).first }

        it 'calculate minimum_month_fee' do
          subject
          expect(current_month_disb.minimum_monthly_fee).not_to eq 0.0
        end

        it 'create additional Disbursment entity' do
          initial_number = merchant.disbursements.size
          subject
          expect(merchant.disbursements.size).not_to eq initial_number
        end
      end
    end
  end

  context 'with no last month orders' do
    context 'with current month orders present' do
      let!(:merchant) { create(:merchant, minimum_monthly_fee: 100.00) }
      let!(:disbursement) { create(:disbursement, merchant_id: merchant.id) }
      let!(:current_month_orders_without_disbursement) do
        create_list(:order, 15, :with_current_month_range, merchant_id: merchant.id, disbursement_id: nil)
      end
      let(:current_month_disb) { merchant.disbursements.where(created_at: Date.current.beginning_of_month..Date.current).first }

      it 'create additional Disbursment entity' do
        initial_number = merchant.disbursements.size
        subject
        expect(merchant.disbursements.size).not_to eq initial_number
      end
    end
  end
end
