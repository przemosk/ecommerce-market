# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Disbursements::GenerateDailyJob, type: :job do
  describe '#perform' do
    it 'enqueue job in generate_disbursement queue' do
      expect { described_class.perform_async }.to enqueue_sidekiq_job(Disbursements::GenerateDailyJob).on('generate_disbursement')
    end
  end
end
