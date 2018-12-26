require 'openssl'
module Mifiel
  module Crypto
    class AES
      CIPHER = 256
      CIPHERS = { 'AES-128-CBC' => 128, 'AES-192-CBC' => 192, 'AES-256-CBC' => 256 }.freeze

      def self.random_iv(size = 16)
        OpenSSL::Random.random_bytes(size)
      end

      def self.encrypt(cipher: CIPHER, key: nil, iv: nil, data: nil)
        aes = Mifiel::Crypto::AES.new(cipher)
        aes.encrypt(key: key, iv: iv, data: data)
      end

      def self.decrypt(cipher: CIPHER, key: nil, iv: nil, data: nil)
        aes = Mifiel::Crypto::AES.new(cipher)
        aes.decrypt(key: key, iv: iv, data: data)
      end

      def self.build_cipher(cipher)
        return OpenSSL::Cipher.new(cipher) if cipher.is_a? String
        OpenSSL::Cipher::AES.new(cipher, :CBC)
      rescue
        raise Mifiel::AESError, 'Cipher not supported'
      end

      attr_accessor :cipher

      def initialize(cipher_id = CIPHER)
        @cipher = Mifiel::Crypto::AES.build_cipher(cipher_id)
      end

      def encrypt(key: nil, iv: nil, data: nil)
        iv ||= Mifiel::Crypto::AES.random_iv(size)
        cipher_final(key, iv, data, action: :encrypt)
      end

      def decrypt(key: nil, iv: nil, data: nil)
        cipher_final(key, iv, data, action: :decrypt)
      end

      def cipher_final(key, iv, message, action: :encrypt)
        @cipher.send(action)
        @cipher.iv = iv
        @cipher.key = key
        @cipher.update(message) + @cipher.final
      end
    end
  end
end
