# frozen_string_literal: true

module Disbursments
  # Job for generate disbursemnts
  # based on daily or weekly orders range
  class DailyOrdersJob
    include Sidekiq::Job

    def perform
      Disbursments::Generate.call
    end
  end
end
