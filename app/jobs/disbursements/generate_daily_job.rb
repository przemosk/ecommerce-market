# frozen_string_literal: true

module Disbursements
  # Job for generate disbursemnts
  # based on daily or weekly orders range
  class GenerateDailyJob
    include Sidekiq::Job
    sidekiq_options queue: :generate_disbursement
    sidekiq_options retry: 3

    def perform
      Disbursements::Generate.call
    end
  end
end
