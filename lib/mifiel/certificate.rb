# frozen_string_literal: true

module Mifiel
  class Certificate < Mifiel::Base
    get :all, '/keys'
    get :find, '/keys/:id'
    put :save, '/keys/:id'
    get :sat, '/keys/sat'

    def self.create(cer_file)
      rest_request = RestClient::Request.new(
        url: "#{Mifiel.config.base_url}/keys",
        method: :post,
        payload: {
          cer_file: File.new(cer_file)
        },
        ssl_version: 'SSLv23'
      )
      req = ApiAuth.sign!(rest_request, Mifiel.config.app_id, Mifiel.config.app_secret, { override_http_method: :post })
      Mifiel::Certificate.new(JSON.parse(req.execute))
    end
  end
end
