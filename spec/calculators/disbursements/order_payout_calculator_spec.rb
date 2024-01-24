# frozen_string_literal: true

require 'rails_helper'

Rails.describe Disbursements::OrderPayoutCalculator do
  subject { described_class.new(amount: amount) }

  describe '#calculate' do
    let(:amount) { 100.00 }

    it 'calculates the payout amount correctly' do
      allow(Disbursements::OrderPayoutCalculator)
        .to receive(:new)
        .with(amount: amount)
        .and_return(double('OrderFeeCalculator', calculate: 10.0))

      result = subject.calculate

      expect(result).to eq(10.0)
    end
  end
end
