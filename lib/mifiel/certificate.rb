module Mifiel
  class Certificate < Mifiel::Base
    get :all, '/keys'
    get :find, '/keys/:id'
    put :save, '/keys/:id'
    get :sat, '/keys/sat'

    def self.create(file:)
      rest_request = RestClient::Request.new(
        url: "#{Mifiel.config.base_url}/keys",
        method: :post,
        payload: {
          cer_file: File.new(file)
        },
        ssl_version: 'SSLv23'
      )
      response = ApiAuth.sign!(rest_request, Mifiel.config.app_id, Mifiel.config.app_secret).execute
      JSON.load(response)
    end
  end
end
