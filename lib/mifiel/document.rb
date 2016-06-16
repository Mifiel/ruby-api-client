require 'open3'

module Mifiel
  class Document < Mifiel::Base
    get :all, '/documents'
    get :find, '/documents/:id'
    put :save, '/documents/:id'
    delete :delete, '/documents/:id'

    def self.create(signatories:, file: nil, hash: nil, callback_url: nil)
      raise ArgumentError, 'Either file or hash must be provided' if !file && !hash
      raise ArgumentError, 'Only one of file or hash must be provided' if file && hash
      sgries = {}
      signatories.each_with_index { |s, i| sgries[i] = s }
      payload = {
        signatories: sgries,
        callback_url: callback_url
      }
      payload[:file] = File.new(file) if file
      payload[:original_hash] = hash if hash
      rest_request = RestClient::Request.new(
        url: "#{Mifiel.config.base_url}/documents",
        method: :post,
        payload: payload,
        ssl_version: 'SSLv23'
      )
      req = ApiAuth.sign!(rest_request, Mifiel.config.app_id, Mifiel.config.app_secret)
      JSON.load(req.execute)
    end

    def request_signature(email, cc: nil)
      params = { email: email }
      params[:cc] = cc if cc.is_a?(Array)
      Mifiel::Document._request("#{Mifiel.config.base_url}/documents/#{id}/request_signature", :post, params)
    end
  end
end
