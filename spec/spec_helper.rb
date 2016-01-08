require 'pry'
require 'byebug'
require 'pry-byebug'
require 'mifiel'
# require 'webmock/rspec'

Dir['./spec/support/**/*.rb'].each { |f| require f }

# WebMock.disable_net_connect!

Mifiel.config do |config|
  config.app_id = '138b94faa5a43d35f60208449f0e0916de29575e'
  config.app_secret = 'mJM3igFcJp8Iu/euEtr0ZTAGixmE+4K5R9o2TEOQEQfAiEuB7MpVwgMULoDxhJvbIUCDZ5l2nnxgL93I5JBXEw=='
  config.base_url = 'http://localhost:3000/api/v1'
end
