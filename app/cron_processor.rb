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

  MONTHS = [nil, 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'June'].freeze

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
    authorize_and_convert_output_values
  end

  def authorize_and_convert_output_values
    @output.each_value do |metric|
      authorize_values(metric)
      convert_values(metric) if metric.is_a?(Month) && MONTHS.include?(metric.value)
    end
  end

  def convert_values(month)
    # receiving Month name and converting to number
    month.value = MONTHS.index(month.value).to_s
  end

  def process
    result = @output.transform_values(&:translate)

    Printer.new.print(result.merge(@command))
  end
end
