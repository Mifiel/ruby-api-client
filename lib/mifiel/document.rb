# frozen_string_literal: true

require 'open3'
require 'api-auth'

module Mifiel
  class Document < Mifiel::Base
    get :all, '/documents'
    get :find, '/documents/:id'

    get :raw_file, '/documents/:id/file', plain: true
    # @deprecated in favor of raw_file
    get :raw_data, '/documents/:id/file', plain: true

    get :raw_file_signed, '/documents/:id/file_signed', plain: true
    # @deprecated in favor of raw_file_signed
    get :raw_signed_data, '/documents/:id/file_signed', plain: true

    get :raw_xml, '/documents/:id/xml', plain: true

    put :save, '/documents/:id'
    delete :delete, '/documents/:id'
    post :create_from_template, '/templates/:template_id/generate_document', timeout: 60
    post :create_many_from_template, '/templates/:template_id/generate_documents', timeout: 60

    # rubocop:disable Metrics/MethodLength
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
        name: name,
      }
      payload = args.merge(payload).compact
      process_request('/documents', :post, payload: payload, type: :form_multipart)
    end
    # rubocop:enable Metrics/MethodLength

    # @deprecated
    def request_signature(email, cc: nil)
      params = { email: email }
      params[:cc] = cc if cc.is_a?(Array)
      Mifiel::Base.process_request("/documents/#{id}/request_signature", :post, payload: params)
    end

    def save_file(path)
      File.binwrite(path, raw_file)
    end

    def save_file_signed(path)
      File.binwrite(path, raw_file_signed)
    end

    def save_xml(path)
      File.write(path, raw_xml)
    end

    def self.build_signatories(signatories)
      sgries = {}
      signatories.each_with_index { |s, i| sgries[i] = s }
      sgries
    end
  end
end
