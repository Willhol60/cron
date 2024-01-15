# frozen_string_literal: true

require_relative 'metric'

class Hour < Metric
  def initialize(value)
    super
    @max = 23
  end

  def translate
    super(@min, @max)
  end
end
