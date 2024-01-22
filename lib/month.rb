# frozen_string_literal: true

require_relative 'metric'

class Month < Metric
  attr_writer :value

  def initialize(value)
    super
    @min = 1
    @max = 12
  end

  def translate
    super(@min, @max)
  end
end
