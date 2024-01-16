# frozen_string_literal: true

require_relative '../../app/printer'

RSpec.describe Printer do
  describe '#print' do
    subject { described_class.new.print(cron_schedule) }

    let(:cron_schedule) do
      {
        'minute' => [1, 2, 3],
        'hour' => [1, 2, 3],
        'dayofmonth' => [1, 2, 3],
        'month' => [1, 2, 3],
        'dayofweek' => [1, 2, 3],
        'command' => ['/usr/bin/find']
      }
    end

    it 'prints the cron schedule' do
      expect { subject }.to output(<<~OUTPUT).to_stdout
        minute        1 2 3
        hour          1 2 3
        dayofmonth    1 2 3
        month         1 2 3
        dayofweek     1 2 3
        command       /usr/bin/find
      OUTPUT
    end
  end
end
