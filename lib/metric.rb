# frozen_string_literal: true

class Metric
  attr_reader :value, :min, :max

  def initialize(value)
    @value = value
    @min = 0
  end

  def translate(min, max)
    if @value.include? '-'
      range
    elsif @value.include? ','
      list
    elsif @value.include? '/'
      step(max)
    elsif @value.include? '*'
      all(min, max)
    else
      [@value.to_i]
    end
  end

  def range
    start, stop = @value.split('-').map(&:to_i)
    (start..stop).to_a
  end

  def list
    @value.split(',').map(&:to_i)
  end

  def step(max)
    # TODO: ensure ( max % value == 0) and provide a range as well as the step (eg. '1-10/2')
    return [] unless @value.include? '*'

    step = @value.split('/').last.to_i
    ((max + 1) / step.to_f).ceil.times.map { |i| i * step }
  end

  def all(min, max)
    (min..max).to_a
  end
end
