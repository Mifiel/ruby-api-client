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

      def set_api_auth_credentials
        Flexirest::Base.base_url = base_url
        Flexirest::Base.api_auth_credentials(app_id, app_secret)
        Flexirest::Base.request_body_type = :json
      end
    end

    reset
  end
end
