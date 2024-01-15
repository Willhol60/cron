# frozen_string_literal: true

require_relative '../../../app/authorizers/fields_authorizer'

RSpec.describe FieldsAuthorizer do
  let(:test_class) { Class.new { extend FieldsAuthorizer } }

  describe '#authorize!' do
    subject { test_class.authorize_fields(fields) }

    context 'when fields are valid' do
      let(:fields) { %w[1 2 3 4 5 /usr/bin/find] }

      it { is_expected.to be_nil }
    end

    context 'when fields are invalid' do
      let(:fields) { %w[1 2 3 4 5] }

      it { expect { subject }.to raise_error(NotEnoughFieldsError) }
    end
  end
end
