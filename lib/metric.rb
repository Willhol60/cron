# frozen_string_literal: true

class Metric
  attr_reader :value, :min, :max

  def initialize(value)
    @value = value
    @min = 0
  end

  def translate(min, max)
    if @value.include? '-'
      range(min, max)
    elsif @value.include? ','
      list
    elsif @value.include? '/'
      step(min, max)
    elsif @value.include? '*'
      all(min, max)
    else
      [@value.to_i]
    end
  end

  private

  def range(min, max)
    start, stop = @value.split('-').map(&:to_i)
    if stop < start
      (start..max).to_a + (min..stop).to_a
    else
      (start..stop).to_a
    end
  end

  def list
    @value.split(',').map(&:to_i)
  end

  def step(min, max)
    # TODO: ensure ( (max + 1) % value == 0) and provide a range as well as the step (eg. '1-10/2')
    return [] unless @value.include? '*'

    step = @value.split('/').last.to_i
    (0..).lazy.map { |v| min + (v * step) }.take_while { |v| v <= max }.to_a
  end

  def all(min, max)
    (min..max).to_a
  end
end
