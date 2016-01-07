require 'open3'

module Mifiel
  class Document < Mifiel::Base

    get :all, '/documents'
    get :find, '/documents/:id'
    put :save, '/documents/:id'
    post :create, '/documents'

    def sign(certificate_id, private_key:nil, private_key_pass:nil, signature:nil)
      fail MifielError, 'Either private_key/private_key_pass or signature must be provided' if !private_key && !signature
      fail MifielError, 'private_key_pass must be provided' if private_key && !private_key_pass
      signature ||= sign_hash(private_key, private_key_pass, original_hash)
      params = {
        key: certificate_id,
        signature: signature
      }
      Mifiel::Document._request("#{Mifiel::BASE_URL}/documents/#{id}/sign", :post, params)
    rescue ActiveRestClient::HTTPClientException => e
      message = e.result.errors || [e.result.error]
      raise MifielError, message.to_a.join(', ')
    rescue ActiveRestClient::HTTPServerException
      raise MifielError, 'Server could not process request'
    end

    private

      def sign_hash(key, pass, hash)
        private_key = build_private_key(key, pass)
        unless private_key.private?
          raise NotPrivateKeyError, "The private key is not valid"
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
        fail PrivateKeyError.new("#{error}, #{status}") unless error.empty?

        OpenSSL::PKey::RSA.new priv_pem_s
      end

  end

end
