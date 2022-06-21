# frozen_string_literal: true

module Mifiel
  class User < Mifiel::Base
    post :setup_widget, '/users/setup-widget'

    def self.setup_widget(args) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      email = args[:email]
      tax_id = args[:tax_id]
      callback_url = args[:callback_url]

      raise ArgumentError, 'Email must be provided' unless email
      raise ArgumentError, 'Tax id must be provided' unless tax_id

      rest_request = RestClient::Request.new(
        url: "#{Mifiel.config.base_url}/users/setup-widget",
        method: :post,
        payload: {
          email: email,
          tax_id: tax_id,
          callback_url: callback_url
        },
        ssl_version: 'SSLv23'
      )
      req = ApiAuth.sign!(rest_request, Mifiel.config.app_id, Mifiel.config.app_secret, { override_http_method: :post, with_http_method: true })
      Mifiel::User.new(JSON.parse(req.execute))
    end
  end
end
