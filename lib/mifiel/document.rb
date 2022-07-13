# frozen_string_literal: true

require 'open3'
require 'api-auth'

module Mifiel
  class Document < Mifiel::Base
    get :all, '/documents'
    get :find, '/documents/:id'
    put :save, '/documents/:id'
    delete :delete, '/documents/:id'
    post :create_from_template, '/templates/:template_id/generate_document', timeout: 60
    post :create_many_from_template, '/templates/:template_id/generate_documents', timeout: 60
    post :transfer, '/documents/:id/transfer', timeout: 60

    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    def self.create(args)
      signatories = args[:signatories]
      file = args[:file]
      hash = args[:hash]
      name = args[:name]
      callback_url = args[:callback_url]
      raise ArgumentError, 'Either file or hash must be provided' if !file && !hash
      raise ArgumentError, 'Only one of file or hash must be provided' if file && hash

      payload = {
        signatories: build_signatories(signatories),
        callback_url: callback_url,
        file: (File.new(file) if file),
        original_hash: hash,
        name: name
      }
      payload = args.merge(payload)
      payload.reject! { |_k, v| v.nil? }
      response = process_request('/documents', :post, payload)
      Mifiel::Document.new(JSON.parse(response))
    end
    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

    def request_signature(email, cc: nil) # rubocop:disable Naming/MethodParameterName
      params = { email: email }
      params[:cc] = cc if cc.is_a?(Array)
      Mifiel::Document._request("#{Mifiel.config.base_url}/documents/#{id}/request_signature", :post, params)
    end

    def raw_data
      response = Mifiel::Document.process_request("/documents/#{id}/file", :get)

      response.body
    end

    def save_file(path)
      File.open(path, 'wb') { |file| file.write(raw_data) }
    end

    def raw_signed_data
      response = Mifiel::Document.process_request("/documents/#{id}/file_signed", :get)

      response.body
    end

    def save_file_signed(path)
      File.open(path, 'wb') { |file| file.write(raw_signed_data) }
    end

    def save_xml(path)
      response = Mifiel::Document.process_request("/documents/#{id}/xml", :get)
      File.open(path, 'w') { |file| file.write(response) }
    end

    def self.process_request(path, method, payload = nil)
      rest_request = RestClient::Request.new(
        url: "#{Mifiel.config.base_url}/#{path.gsub(%r{^\/}, '')}",
        method: method,
        payload: payload,
        ssl_version: 'SSLv23'
      )
      req = ApiAuth.sign!(rest_request, Mifiel.config.app_id, Mifiel.config.app_secret)
      req.execute
    end

    def self.build_signatories(signatories)
      sgries = {}
      signatories.each_with_index { |s, i| sgries[i] = s }
      sgries
    end

    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    def self.transfer_from_template(args)
      id = args[:document_id]

      payload = {
        from: args[:from],
        to: args[:to],
        signatories: args[:signatories],
        template_id: args[:template_id],
        fields: args[:fields],
        callback_url: args[:callback_url],
        sign_callback_url: args[:sign_callback_url],
        allow_business: args[:allow_business],
        external_id: args[:external_id]
      }
      payload.reject! { |_k, v| v.nil? }

      response = Mifiel::Document.process_request("/documents/#{id}/transfer", :post, payload)
      Mifiel::Document.new(JSON.parse(response))
    end
    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
  end
end
