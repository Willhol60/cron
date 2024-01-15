#! /usr/bin/env ruby
# frozen_string_literal: true

require_relative 'cron_processor'

CronProcessor.new(ARGV[0]).process
