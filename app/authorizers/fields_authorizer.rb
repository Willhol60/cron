# frozen_string_literal: true

NotEnoughFieldsError = Class.new(StandardError)

module FieldsAuthorizer
  def authorize_fields(fields)
    raise NotEnoughFieldsError unless fields.size >= 6
  end
end
