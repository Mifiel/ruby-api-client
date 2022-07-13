# frozen_string_literal: true

require 'pry'
require 'mifiel'
require 'webmock/rspec'
require 'simplecov'
require 'coveralls'

SimpleCov.start do
  add_filter '/spec/'
end

Coveralls.wear!

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

RSpec.configure do |config|
  config.before(:suite) do
    Mifiel.config do |conf|
      conf.app_id = 'APP_ID'
      conf.app_secret = 'APP_SECRET'
      conf.base_url = 'http://www.mifiel.com/api/v1'
    end

    # Creates ruby-api-client/tmp folder so signed files can be saved correctly
    Dir.mkdir 'tmp' unless File.directory? 'tmp'
  end

  config.before(:each) do
    stub_request(:any, /mifiel.com/).to_rack(FakeMifiel)
  end
end
