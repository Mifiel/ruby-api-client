# frozen_string_literal: true

module Mifiel
  module Config
    class << self
      attr_reader :app_id, :app_secret, :base_url

      def reset
        @app_id = nil
        @app_secret = nil
        @base_url = Mifiel::BASE_URL
      end

      def app_id=(app_id)
        @app_id = app_id
        set_api_auth_credentials
      end

      def app_secret=(app_secret)
        @app_secret = app_secret
        set_api_auth_credentials
      end

      def base_url=(base_url)
        @base_url = base_url
        set_api_auth_credentials
      end

      private

      def set_api_auth_credentials # rubocop:disable Metrics/MethodLength
        Flexirest::Base.base_url = base_url
        Flexirest::Base.api_auth_credentials(
          app_id,
          app_secret,
          with_http_method: true,
          digest: 'sha1',
        )
        Flexirest::Base.request_body_type = :json
        Flexirest::Base.faraday_config do |faraday|
          faraday.headers['User-Agent'] = user_agent
          faraday.headers['X-ORIGINAL-URI'] = faraday.path_prefix
        end
      end

      def user_agent
        [
          "#{Gem::Platform::RUBY.upcase}/#{RUBY_VERSION}",
          "mifiel/#{Mifiel::VERSION}",
          "faraday/#{Faraday::VERSION}",
          # there is no easy way to get OS version in ruby
          "(#{RUBY_PLATFORM}/-)",
        ].join(' ')
      end
    end

    reset
  end
end
