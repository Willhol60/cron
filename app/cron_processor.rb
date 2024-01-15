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
    fields = cron_string.split
    @invalid_fields_message = authorize_fields(fields)
    return if @invalid_fields_message

    @output = {
      minute: Minute.new(fields[0]),
      hour: Hour.new(fields[1]),
      day_of_month: DayOfMonth.new(fields[2]),
      month: Month.new(fields[3]),
      day_of_week: DayOfWeek.new(fields[4])
    }
    @command = { command: fields[5] }
    authorize_all_values
  end

  def authorize_all_values
    @output.each_value { |metric| authorize_values(metric) }
  end

  def process
    return @invalid_fields_message if @invalid_fields_message

    result = @output.transform_values(&:translate)

    Printer.new.print(result.merge(@command))
  end
end
