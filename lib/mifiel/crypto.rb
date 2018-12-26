require_relative '../core_extensions.rb'
CoreExtensions.load

module Mifiel
  module Crypto
    autoload :PBE, 'mifiel/crypto/pbe'
    autoload :Response, 'mifiel/crypto/response'
    autoload :AES, 'mifiel/crypto/aes'
    autoload :ECIES, 'mifiel/crypto/ecies'
    autoload :PKCS5, 'mifiel/crypto/pkcs5'

    def self.decrypt(asn1, pass)
      pkcs5 = Mifiel::Crypto::PKCS5.parse(asn1.force_binary)
      params = pkcs5.values
      params[:data] = params[:cipher_text]
      params[:key] =
        Mifiel::Crypto::PBE.derive_key({ password: pass }.merge(params.slice(:salt, :iterations, :key_size)))
      Mifiel::Crypto::AES.decrypt(params.slice(:key, :data, :iv, :cipher))
    end

    def self.encrypt(document, password)
      params = {
        salt: Mifiel::Crypto::PBE.random_salt,
        iterations: Mifiel::Crypto::PBE::ITERATIONS,
        password: password
      }
      params[:key] = Mifiel::Crypto::PBE.derive_key(params)
      params[:iv] = Mifiel::Crypto::AES.random_iv
      params[:data] = document
      params[:cipher_text] = Mifiel::Crypto::AES.encrypt(params.slice(:key, :iv, :data))
      Mifiel::Crypto::PKCS5.new(params.slice(:salt, :iv, :iterations, :cipher_text))
    end
  end
end
