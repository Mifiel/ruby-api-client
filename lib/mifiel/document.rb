require 'open3'

module Mifiel
  class Document < Mifiel::Base
    get :all, '/documents'
    get :find, '/documents/:id'
    put :save, '/documents/:id'
    delete :delete, '/documents/:id'

    def self.create(file:, signatories:, hash:nil)
      sgries = {}
      signatories.each_with_index { |s, i| sgries[i] = s }
      rest_request = RestClient::Request.new(
        url: "#{Mifiel.config.base_url}/documents",
        method: :post,
        payload: {
          file: File.new(file),
          hash: hash,
          signatories: sgries
        },
        ssl_version: 'SSLv23'
      )
      req = ApiAuth.sign!(rest_request, Mifiel.config.app_id, Mifiel.config.app_secret)
      JSON.load(req.execute)
    end

    def sign(certificate_id:nil, certificate:nil)
      fail ArgumentError, 'Either certificate_id or certificate must be provided' if !certificate_id && !certificate
      fail ArgumentError, 'Only one of certificate_id or certificate must be provided' if certificate_id && certificate
      fail NoSignatureError, 'You must first call build_signature or provide a signature' unless signature
      params = { signature: signature }
      params[:key] = certificate_id if certificate_id
      if certificate
        if certificate.encoding.to_s == 'UTF-8'
          params[:certificate] = certificate.unpack('H*')[0]
        else
          params[:certificate] = certificate
        end
      end

      Mifiel::Document._request("#{Mifiel.config.base_url}/documents/#{id}/sign", :post, params)
    rescue ActiveRestClient::HTTPClientException => e
      message = e.result.errors || [e.result.error]
      raise MifielError, message.to_a.join(', ')
    rescue ActiveRestClient::HTTPServerException
      raise MifielError, 'Server could not process request'
    end

    def request_signature(email, cc:nil)
      params = { email: email }
      params[:cc] = cc if cc.is_a?(Array)
      Mifiel::Document._request("#{Mifiel.config.base_url}/documents/#{id}/request_signature", :post, params)
    rescue ActiveRestClient::HTTPClientException => e
      message = e.result.errors || [e.result.error]
      raise MifielError, message.to_a.join(', ')
    rescue ActiveRestClient::HTTPServerException
      raise MifielError, 'Server could not process request'
    end

    def build_signature(private_key, private_key_pass)
      self.signature ||= sign_hash(private_key, private_key_pass, original_hash)
    end

    private

      # Sign the provided hash
      # @param key [String] The contents of the .key file (File.read(...))
      # @param pass [String] The password of the key
      # @param hash [String] The hash or string to sign
      #
      # @return [String] Hex string of the signature
      def sign_hash(key, pass, hash)
        private_key = build_private_key(key, pass)
        unless private_key.private?
          fail NotPrivateKeyError, 'The private key is not valid'
        end
        signature = private_key.sign(OpenSSL::Digest::SHA256.new, hash)
        signature.unpack('H*')[0]
      end

      def build_private_key(private_data, key_pass)
        # create file so we can converted to pem
        private_file = File.new("./tmp/tmp-#{rand(1000)}.key", 'w+')
        private_file.write(private_data.force_encoding('UTF-8'))
        private_file.close

        key2pem_command = "openssl pkcs8 -in #{private_file.path} -inform DER -passin pass:#{key_pass}"
        priv_pem_s, error, status = Open3.capture3(key2pem_command)

        # delete file from file system
        File.unlink private_file.path
        fail PrivateKeyError, "#{error}, #{status}" unless error.empty?

        OpenSSL::PKey::RSA.new priv_pem_s
      end
  end
end
