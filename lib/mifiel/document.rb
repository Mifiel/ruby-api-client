module Mifiel
  class Document < Mifiel::Base

    get :all, '/documents'
    get :find, '/documents/:id'
    put :save, '/documents/:id'
    post :create, '/documents'

    def sign(certificate_id, private_key:nil, signature:nil)
      fail MifielError, 'Either private_key or signature must be provided' if !private_key && !signature
      signature ||= sign_hash(private_key, original_hash)
      url = "#{Mifiel::BASE_URL}/documents/#{id}/sign"
      params = {
        key: certificate_id,
        signature: signature
      }
      Mifiel::Document._request(url, :post, params)
    rescue ActiveRestClient::HTTPClientException => e
      message = e.result.errors || [e.result.error]
      raise MifielError, message.to_a.join(', ')
    rescue ActiveRestClient::HTTPServerException
      raise MifielError, 'Server could not process request'
    end

    private

      def sign_hash(key, hash)
        digest = OpenSSL::Digest::SHA256.new
        ""
      end

  end

end
