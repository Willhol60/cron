# frozen_string_literal: true

module InvalidInputs
  InvalidRangeInput = Class.new(StandardError)
  InvalidListInput = Class.new(StandardError)
  NotEnoughFields = Class.new(StandardError)
end
