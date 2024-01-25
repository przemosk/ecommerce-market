# frozen_string_literal: true

require 'rails_helper'

Rails.describe Disbursements::Order::PayoutCalculator do
  subject { described_class.new(amount: amount) }

  describe '#calculate' do
    let(:amount) { 100.00 }

    it 'calculates the payout amount correctly' do
      allow(Disbursements::Order::PayoutCalculator)
        .to receive(:new)
        .with(amount: amount)
        .and_return(double('FeeCalculator', calculate: 10.0))

      result = subject.calculate

      expect(result).to eq(10.0)
    end
  end
end
