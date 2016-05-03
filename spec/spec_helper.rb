require "rspec/expectations"
require 'coveralls'
require 'simplecov'
SimpleCov.start

RSpec.configure do |config|
  # ...
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
