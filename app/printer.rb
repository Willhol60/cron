# frozen_string_literal: true

class Printer
  def print(cron_schedule)
    cron_schedule.each do |time, v|
      time = time.to_s.ljust(14)
      v = v.join(' ')
      puts [time, v].join
    end
  end
end
