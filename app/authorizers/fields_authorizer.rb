# frozen_string_literal: true

module FieldsAuthorizer
  def authorize_fields(fields)
    raise InvalidInputs::NotEnoughFields unless fields.size >= 6
  end
end
