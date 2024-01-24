# frozen_string_literal: true

# Base Calculator class
class BaseCalculator
  def calculate
    raise NotImplementedError, "Please implement #{calculate} metod"
  end
end
