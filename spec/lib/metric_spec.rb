# frozen_string_literal: true

require_relative '../../lib/metric'

RSpec.describe Metric do
  describe '#translate' do
    subject { described_class.new(field).translate(min, max) }

    let(:min) { 0 }
    let(:max) { 5 }

    context 'when field is a range' do
      let(:field) { "#{min + 1} - #{max}" }

      it { is_expected.to eq(((min + 1)..max).to_a) }
    end

    context 'when field is a list' do
      let(:field) { "#{min}, #{max}" }

      it { is_expected.to eq([min, max]) }
    end

    context 'when field is a step' do
      context 'when field includes an asterisk' do
        let(:field) { '*/2' }

        it { is_expected.to eq([0, 2, 4]) }

        context 'when min is not 0' do
          let(:min) { 1 }

          it { is_expected.to eq([1, 3, 5]) }
        end
      end

      context 'another one with an asterisk' do
        let(:max) { 12 }
        let(:field) { '*/3' }

        it { is_expected.to eq([0, 3, 6, 9, 12]) }

        context 'when min is not 0' do
          let(:min) { 1 }

          it { is_expected.to eq([1, 4, 7, 10]) }
        end
      end

      context 'when field does not include an asterisk' do
        let(:field) { '1/2' }

        it { is_expected.to eq([]) }
      end
    end

    context 'when all values are specified (*)' do
      let(:field) { '*' }

      it { is_expected.to eq((min..max).to_a) }
    end

    context 'when field is a single value' do
      let(:field) { '1' }

      it { is_expected.to eq([1]) }
    end
  end
end
