require 'bundler/setup'
Bundler.setup

require 'pry'
require 'rspec'

RSpec.configure do |config|
  config.color = true
  config.tty = true
  config.formatter = :documentation
end