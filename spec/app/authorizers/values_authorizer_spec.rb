# frozen_string_literal: true

require_relative '../../../app/authorizers/values_authorizer'

RSpec.describe ValuesAuthorizer do
  let(:test_class) { Class.new { extend ValuesAuthorizer } }

  describe '#authorize_values' do
    subject { test_class.authorize_values(object) }

    let(:object) { double('object', value: value, min: min, max: max) }
    let(:value) { '*' }
    let(:min) { 1 }
    let(:max) { 31 }

    context 'when values are valid' do
      it { is_expected.to eq object }
    end

    context 'when range values are invalid' do
      let(:value) { '1-32' }
      it { expect { subject }.to raise_error(InvalidInputs::InvalidRangeInput) }
    end

    context 'when list values are invalid' do
      let(:value) { '1,32' }
      it { expect { subject }.to raise_error(InvalidInputs::InvalidListInput) }
    end
  end
end
