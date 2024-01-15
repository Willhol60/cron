# frozen_string_literal: true

require 'pry'

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
    @invalid_fields_message = authorize_fields fields
    return if @invalid_fields_message

    @minute = Minute.new(fields[0])
    @hour = Hour.new(fields[1])
    @day_of_month = DayOfMonth.new(fields[2])
    @month = Month.new(fields[3])
    @day_of_week = DayOfWeek.new(fields[4])
    authorize_all_values

    @command = fields[5]
  end

  def authorize_all_values
    instance_variables[1..].each do |var|
      authorize_values(instance_variable_get(var))
    end
  end

  def process
    return @invalid_fields_message if @invalid_fields_message

    result = instance_variables[1...-1].map do |var| # not scaleable/extendible to use indices
      instance_variable_get(var).translate
    end
    Printer.new.print(result.push(@command))
  end
end
