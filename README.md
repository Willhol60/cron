# Cron 

This app parses a cron string and expands each field to show the times at which the operation will run.

## Components:

- **run_cron** - receives the user input and sends to cron_processor
- **cron_processor** - co-ordinator for the app
- **metric** - ancestor and source of logic for all the other metric classes
- **authorizers** - logic for authorizing input

## Running

```bash
app/run_cron.rb #{cron_string}
```
See examples below.

## Requirements

Ruby 3.0.3 or higher

The app doesn't use any libraries and can be run in any Ruby environment. It's necessary to install gems with `bundle install` to be able to run the checks.

## Available commands

```bash
rspec
rubocop
```

## Examples

#### Valid args 1
`app/run_cron.rb '1-15 0-1 1-15 1-5 1-5 /usr/bin/find'`

#### Valid args 2
`app/run_cron.rb '*/15 */3 1,2,15 1 1-5 ls -l /usr/bin/find'`

#### Invalid args (invalid range error)
`app/run_cron.rb '1-150 0-1 1-15 1-5 1-5 /usr/bin/find'`

#### Invalid args (invalid list error)
`app/run_cron.rb '1,150 0-1 1-15 1-5 1-5 /usr/bin/find'`
