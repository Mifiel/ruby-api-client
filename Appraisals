# frozen_string_literal: true

appraise 'rails-7' do
  gem 'rails', '~> 7.2.0'
  # ActiveSupport 7.2 still calls JSON.generate(quirks_mode: true), which json 3 dropped.
  gem 'json', '< 3'
  gem 'mutex_m'
  gem 'benchmark'
  gem 'ostruct'
end

appraise 'rails-8' do
  # 8.0.x still passes quirks_mode; 8.1 removed it and works with json 3.
  gem 'rails', '~> 8.1.0'
end
