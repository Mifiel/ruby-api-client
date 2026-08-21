# frozen_string_literal: true

require 'webmock/rspec'
require 'simplecov'
require 'rack'
require 'byebug'

SimpleCov.start do
  add_filter '/spec/'
end

require 'mifiel'

Dir[File.expand_path(File.join(File.dirname(__FILE__), 'support', '**', '*.rb'))].each { |f| require f }

RSpec.configure do |config|
  config.before(:suite) do
    Mifiel.config do |conf|
      conf.app_id = 'APP_ID'
      conf.app_secret = 'APP_SECRET'
      conf.base_url = 'https://app.mifiel.com/api/v1'
    end

    # Creates ruby-api-client/tmp folder so signed files can be saved correctly
    FileUtils.mkdir_p('tmp') unless File.directory?('tmp')

    # Stub all requests to mifiel.com
    stub_request(:any, /mifiel.com/).to_rack(FakeMifiel)
  end
end
