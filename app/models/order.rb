# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :merchant

  # TODO: add some validation
end
