# frozen_string_literal: true

module FieldsAuthorizer
  def authorize_fields(fields)
    'Invalid input' unless fields.size == 6
  end
end
