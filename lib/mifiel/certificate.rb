# frozen_string_literal: true

module Mifiel
  class Certificate < Mifiel::Base
    get :all, '/keys'
    get :find, '/keys/:id'
    put :save, '/keys/:id'
    get :sat, '/keys/sat'

    def self.create(cer_file)
      payload = { cer_file: File.new(cer_file) }
      process_request('/keys', :post, payload: payload, type: :form_multipart)
    end
  end
end
