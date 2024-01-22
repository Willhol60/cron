# frozen_string_literal: true

require_relative '../../app/cron_processor'

RSpec.describe CronProcessor do
  describe '#initialize' do
    subject { described_class.new(input) }

    context 'with invalid range values' do
      let(:input) { '1-150 0 1,12 * 1-5 /usr/bin/find' }

      it { expect { subject }.to raise_error(InvalidRangeInputError) }
    end

    context 'with invalid list values' do
      let(:input) { '1,150 0 1,12 * 1-5 /usr/bin/find' }

      it { expect { subject }.to raise_error(InvalidListInputError) }
    end
  end

  describe '#process' do
    subject { described_class.new(input).process }

    context 'with valid input 1' do
      let(:input) { '*/15 0 1,12 * 1-5 /usr/bin/find' }

      it {
        is_expected.to eq({
                            minute: [0, 15, 30, 45],
                            hour: [0],
                            day_of_month: [1, 12],
                            month: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
                            day_of_week: [1, 2, 3, 4, 5],
                            command: ['/usr/bin/find']
                          })
      }
    end

    context 'with valid input 2' do
      let(:input) { '10 0-4 4-7 1,12 * do/this/now' }

      it {
        is_expected.to eq({
                            minute: [10],
                            hour: [0, 1, 2, 3, 4],
                            day_of_month: [4, 5, 6, 7],
                            month: [1, 12],
                            day_of_week: [1, 2, 3, 4, 5, 6, 7],
                            command: ['do/this/now']
                          })
      }
    end

    context 'with valid input 3 - space in command' do
      let(:input) { '10 0-4 4-7 1,12 * do/this now' }

      it {
        is_expected.to eq({
                            minute: [10],
                            hour: [0, 1, 2, 3, 4],
                            day_of_month: [4, 5, 6, 7],
                            month: [1, 12],
                            day_of_week: [1, 2, 3, 4, 5, 6, 7],
                            command: ['do/this', 'now']
                          })
      }
    end

    context 'with valid input 4 - space in command with additional tags' do
      let(:input) { '10 0-4 4-7 1,12 * do/this now -v foo -l bar' }

      it {
        is_expected.to eq({
                            minute: [10],
                            hour: [0, 1, 2, 3, 4],
                            day_of_month: [4, 5, 6, 7],
                            month: [1, 12],
                            day_of_week: [1, 2, 3, 4, 5, 6, 7],
                            command: ['do/this', 'now', '-v', 'foo', '-l', 'bar']
                          })
      }
    end

    context 'with valid input 4 - converting month name' do
      let(:input) { '10 0-4 4-7 Jan * do/this now -v foo -l bar' }

      it {
        is_expected.to eq({
                            minute: [10],
                            hour: [0, 1, 2, 3, 4],
                            day_of_month: [4, 5, 6, 7],
                            month: [1],
                            day_of_week: [1, 2, 3, 4, 5, 6, 7],
                            command: ['do/this', 'now', '-v', 'foo', '-l', 'bar']
                          })
      }
    end

    context 'with input of incorrect length (no command included)' do
      let(:input) { '*/15 0 1,15 * 1-5' }

      it { expect { subject }.to raise_error(NotEnoughFieldsError) }
    end
  end
end
