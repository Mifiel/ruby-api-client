require 'openssl'
module Mifiel
  module Crypto
    class AES
      CIPHER = 256
      SIZE = 16

      def self.random_iv(size = SIZE)
        OpenSSL::Random.random_bytes(size)
      end

      def self.encrypt(cipher: CIPHER, key: nil, iv: nil, data: nil)
        aes = Mifiel::Crypto::AES.new(cipher)
        args = { cipher: cipher, key: key, iv: iv, data: data }
        aes.encrypt(args)
      end

      def self.decrypt(cipher: CIPHER, key: nil, iv: nil, data: nil)
        aes = Mifiel::Crypto::AES.new(cipher)
        args = { cipher: cipher, key: key, iv: iv, data: data }
        aes.decrypt(args)
      end

      attr_accessor :cipher, :require_args

      def initialize(cipher_type = CIPHER)
        @require_args = [:key, :iv, :data]
        @cipher = OpenSSL::Cipher::AES.new(cipher_type, :CBC)
      end

      def random_iv(size = SIZE)
        Mifiel::Crypto::AES.random_iv(size)
      end

      def encrypt(key: nil, iv: nil, data: nil)
        iv ||= random_iv
        Encrypted.new(cipher_final(key, iv, data, action: :encrypt))
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

    class Encrypted < Mifiel::Crypto::Response
      def to_str
        data
      end
    end
  end
end
