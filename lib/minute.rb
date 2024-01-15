# frozen_string_literal: true

require_relative 'metric'

class Minute < Metric
  def initialize(value)
    super
    @max = 59
  end

  def translate
    super(@min, @max)
  end
end
