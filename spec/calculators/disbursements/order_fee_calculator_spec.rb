# frozen_string_literal: true

require 'rails_helper'

Rails.describe Disbursements::OrderFeeCalculator do
  subject { described_class.new(amount: amount) }

  describe '#calculate' do
    context 'when amount smaller than 50' do
      let(:amount) { 48.88 }

      it 'return result multipled by 0.01' do
        result = subject.calculate

        expect(result).to eq (amount * 0.01).round(2)
      end
    end

    context 'when amount is between 50 and 300' do
      let(:amount) { 150.00 }

      it 'return result multipled by 0.0095' do
        result = subject.calculate

        expect(result).to eq (amount * 0.0095).round(2)
      end
    end

    context 'when bigger than 300' do
      let(:amount) { 420.00 }

      it 'return result multipled by 0.0085' do
        result = subject.calculate

        expect(result).to eq (amount * 0.0085).round(2)
      end
    end
  end
end
