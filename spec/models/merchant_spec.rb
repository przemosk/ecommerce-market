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
require 'rails_helper'

Rails.describe Merchant, type: :model do
  subject { described_class }

  describe '.scopes' do
    let!(:daily_merchants) { create_list(:merchant, 5, disbursement_frequency: 0) }
    let!(:weekly_merchants) { create_list(:merchant, 3, disbursement_frequency: 1, live_on: Date.current) }
    let!(:weekly_merchants1) { create_list(:merchant, 2, disbursement_frequency: 1, live_on: Date.current.yesterday) }

    describe '.with_daily_payouts' do
      context 'contain only merchant with disbursement_frequency: daily' do
        it 'return merchants for daily disbursement' do
          result = subject.with_daily_payouts

          expect(result.pluck(:disbursement_frequency).uniq.first).to eq 'daily'
          expect(result.size).to eq 5
        end
      end
    end

    describe '.with_weekly_payouts' do
      context 'contain only merchant with disbursement_frequency: weekly' do
        it 'return merchants for daily disbursement' do
          result = subject.with_weekly_payouts

          expect(result.pluck(:disbursement_frequency).uniq.first).to eq 'weekly'
          expect(result.size).to eq 3
        end
      end
    end

    describe '#calculate_previous_month_fee' do
      let!(:merchant) { create(:merchant) }

      context 'when there are orders in previous month' do
        let!(:last_week_disbursement) do
          create_list(:disbursement, 5, :within_weekly_range, merchant_id: merchant.id, commision_amount: 10.00)
        end
        let!(:last_month_disbursement) do
          create_list(:disbursement, 20, :within_monthly_range, merchant_id: merchant.id, commision_amount: 5.00)
        end

        it 'calculate amount correctly' do
          expect(merchant.calculate_last_month_disbursement_fee).to eq (20 * 5.00).round(2)
        end
      end

      context 'when there no orders in previus month' do
        it 'calculate amount correctly' do
          expect(merchant.disbursements.size).to eq 0
          expect(merchant.calculate_last_month_disbursement_fee).to eq (0 * 0.00).round(2)
        end
      end
    end
  end

  describe '#first_disbursement_in_current_month?' do
    let!(:merchant) { create(:merchant) }

    context 'when there was no disbursement before' do
      it 'reuturn true' do
        expect(merchant.first_disbursement_in_current_month?).to eq true
      end
    end

    context 'when there was no disbursement before' do
      let!(:merchant) { create(:merchant) }
      let!(:disbursement) { create(:disbursement, :within_daily_range, merchant_id: merchant.id) }

      it 'reuturn false' do
        expect(merchant.first_disbursement_in_current_month?).to eq false
      end
    end
  end

  describe '#orders_for_daily_disbursement_collection' do
    let!(:merchant) { create(:merchant) }
    let!(:disbursement) { create(:disbursement, merchant_id: merchant.id) }
    let!(:last_week_orders) { create_list(:order, 2, :withing_daily_range, merchant_id: merchant.id, disbursement_id: nil) }
    let!(:last_month_orders) { create_list(:order, 3, :within_monthly_range, merchant_id: merchant.id, disbursement_id: disbursement.id) }

    context 'when merchant orders' do
      it 'return merchant orders from yesterday within disbrusement_id: nil' do
        expect(merchant.orders.size).to eq 5
        result = merchant.orders_for_daily_disbursement_collection
        expect(result.size).to eq 2
        expect(result.pluck(:disbursement_id).uniq.first).to eq nil
      end
    end
  end

  describe '#orders_for_weekly_disbursement_collection' do
    let!(:merchant) { create(:merchant) }
    let!(:disbursement) { create(:disbursement, merchant_id: merchant.id) }
    let!(:last_week_orders) { create_list(:order, 4, :withing_weekly_range, merchant_id: merchant.id, disbursement_id: nil) }
    let!(:last_month_orders) { create_list(:order, 2, :within_monthly_range, merchant_id: merchant.id, disbursement_id: disbursement.id) }

    context 'when merchant orders' do
      it 'return merchant orders from last week within disbrusement_id: nil' do
        expect(merchant.orders.size).to eq 6
        result = merchant.orders_for_weekly_disbursement_collection
        expect(result.size).to eq 4
        expect(result.pluck(:disbursement_id).uniq.first).to eq nil
      end
    end
  end
end
