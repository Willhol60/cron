# frozen_string_literal: true

require_relative '../../lib/errors/input_error'

module ValuesAuthorizer
  include InvalidInputs

  def authorize_values(obj)
    if obj.value.include? '-'
      range_authorize obj
    elsif obj.value.include? ','
      list_range_authorize obj
    else
      obj
    end
  end

  def range_authorize(obj)
    first, last = obj.value.split('-').map(&:to_i)

    return obj if first >= obj.min && last <= obj.max

    raise InvalidInputs::InvalidRangeInput, "Please ensure the range is within #{obj.min} and #{obj.max}"
  end

  def list_range_authorize(obj)
    list = obj.value.split(',').map(&:to_i).sort

    return obj if list.first >= obj.min && list.last <= obj.max

    raise InvalidInputs::InvalidListInput, "Please ensure the list values are within the range #{obj.min} - #{obj.max}"
  end
end
