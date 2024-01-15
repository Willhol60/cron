# frozen_string_literal: true

require_relative 'metric'

class DayOfWeek < Metric
  def initialize(value)
    super
    @min = 1
    @max = 7
  end

  def translate
    super(@min, @max)
  end
end
