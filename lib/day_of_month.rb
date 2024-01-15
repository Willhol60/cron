# frozen_string_literal: true

require_relative 'metric'

class DayOfMonth < Metric
  def initialize(value)
    super
    @min = 1
    @max = 31 # ideally dynamic based on the month
  end

  def translate
    super(@min, @max)
  end
end
