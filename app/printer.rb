# frozen_string_literal: true

class Printer
  def print(hash)
    hash.each do |metric, v|
      metric = metric.to_s.ljust(14)
      v = v.join(' ') unless v.is_a? String
      puts [metric, v].join(' ')
    end
  end
end
