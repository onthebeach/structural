require 'rspec'
require 'lib/structural'
require 'simplecov'

SimpleCov.start if ENV['COVERAGE']

I18n.enforce_available_locales = false

RSpec.configure do |config|
  config.order = :rand
  config.color_enabled = true
end
