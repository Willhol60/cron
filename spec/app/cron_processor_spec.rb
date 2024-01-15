# frozen_string_literal: true

require_relative '../../app/cron_processor'

RSpec.describe CronProcessor do
  describe '#initialize' do
    subject { described_class.new(input) }

    context 'with invalid range values' do
      let(:input) { '1-150 0 1,12 * 1-5 /usr/bin/find' }

      it { expect { subject }.to raise_error(InvalidInputs::InvalidRangeInput) }
    end

    context 'with invalid list values' do
      let(:input) { '1,150 0 1,12 * 1-5 /usr/bin/find' }

      it { expect { subject }.to raise_error(InvalidInputs::InvalidListInput) }
    end
  end

  describe '#process' do
    subject { described_class.new(input).process }

    context 'with valid input 1' do
      let(:input) { '*/15 0 1,12 * 1-5 /usr/bin/find' }

      it {
        is_expected.to eq([[0, 15, 30, 45], [0], [1, 12], [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], [1, 2, 3, 4, 5],
                           '/usr/bin/find'])
      }
    end

    context 'with valid input 2' do
      let(:input) { '10 0-4 4-7 1,12 * do/this/now' }

      it { is_expected.to eq([[10], [0, 1, 2, 3, 4], [4, 5, 6, 7], [1, 12], [1, 2, 3, 4, 5, 6, 7], 'do/this/now']) }
    end

    context 'with input of incorrect length (no command included)' do
      let(:input) { '*/15 0 1,15 * 1-5' }

      it { is_expected.to eq('Invalid input') }
    end
  end
end
