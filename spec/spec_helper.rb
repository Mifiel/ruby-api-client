require 'pry'
require 'byebug'
require 'pry-byebug'
require 'mifiel'
# require 'webmock/rspec'

Dir['./spec/support/**/*.rb'].each { |f| require f }

# WebMock.disable_net_connect!

Mifiel.config do |c|
  c.app_id = 'c813b1c5f4e1af7edb6900c684421299dac7d5ae'
  c.app_secret = 'p6kktpXjcJan0cwr9tEN2iJztULN+7WyIfbrjDZKsx+3aWePU15NOr0NcJJMtMlCyeVQumDpSv1lWF/S2xe1qQ=='
end
