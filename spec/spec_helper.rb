require 'mifiel'
require 'webmock/rspec'

require 'simplecov'
require 'coveralls'
SimpleCov.start do
  add_filter '/spec/'
end
Coveralls.wear!

Dir['./spec/support/**/*.rb'].each { |f| require f }

RSpec.configure do |config|

  config.before(:suite) do
    Mifiel.config do |conf|
      conf.app_id = 'APP_ID'
      conf.app_secret = 'APP_SECRET'
      conf.base_url = 'http://www.mifiel.com/api/v1'
    end
  end

  config.before(:each) do
    stub_request(:any, /mifiel.com/).to_rack(FakeMifiel)
  end
end
