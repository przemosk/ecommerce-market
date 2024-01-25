# frozen_string_literal: true

require 'rails_helper'

Rails.describe Disbursements::MinimumMonthlyFeeCalculator do
  subject { described_class.new(min_monthly_merchant_fee: min_monthly_merchant_fee, last_month_merchant_fees: last_month_fees_sum) }

  describe '#calculate' do
    context 'when last_month_fee is less than merchant minimum monthly fee' do
      let!(:last_month_fees_sum) { 25.0 }
      let!(:min_monthly_merchant_fee) { 50.0 }

      it 'calculates correct amount' do
        result = subject.calculate

        expect(result).to eq(min_monthly_merchant_fee - last_month_fees_sum)
      end
    end

    context 'when last_month_fee is bigger than merchant minimum monthly fee' do
      let!(:last_month_fees_sum) { 25.0 }
      let!(:min_monthly_merchant_fee) { 10.0 }

      it 'calculates correct amount' do
        result = subject.calculate

        expect(result).to eq 0.00
      end
    end

    context 'when last_month_fee is equal to merchant minimum monthly fee' do
      let!(:last_month_fees_sum) { 25.0 }
      let!(:min_monthly_merchant_fee) { 25.0 }

      it 'calculates correct amount' do
        result = subject.calculate

        expect(result).to eq 0.00
      end
    end
  end
end
