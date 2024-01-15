# frozen_string_literal: true

require_relative 'authorizers/fields_authorizer'
require_relative 'authorizers/values_authorizer'
require_relative '../lib/minute'
require_relative '../lib/hour'
require_relative '../lib/day_of_month'
require_relative '../lib/month'
require_relative '../lib/day_of_week'
require_relative 'printer'

class CronProcessor
  include FieldsAuthorizer
  include ValuesAuthorizer

  def initialize(cron_string)
    authorize_fields(cron_string.split)
    minute, hour, dom, month, dow, *command = cron_string.split

    @output = {
      minute: Minute.new(minute),
      hour: Hour.new(hour),
      day_of_month: DayOfMonth.new(dom),
      month: Month.new(month),
      day_of_week: DayOfWeek.new(dow)
    }
    @command = { command: command }
    authorize_output_values
  end

  def authorize_output_values
    @output.each_value { |metric| authorize_values(metric) }
  end

  def process
    result = @output.transform_values(&:translate)

    Printer.new.print(result.merge(@command))
  end
end
