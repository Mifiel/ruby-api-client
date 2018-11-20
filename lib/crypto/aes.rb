require 'openssl'

module Crypto
  class AES
    CIPHER = 256
    SIZE = 16

    def self.random_iv(size = SIZE)
      OpenSSL::Random.random_bytes(size)
    end

    def self.encrypt(args)
      aes = Crypto::AES.new(args[:cipher] || CIPHER)
      aes.encrypt(args)
    end

    def self.decrypt(args)
      aes = Crypto::AES.new(args[:cipher] || CIPHER)
      aes.decrypt(args)
    end

    attr_accessor :cipher, :require_args

    def initialize(cipher_type = CIPHER)
      @require_args = [:key, :iv, :data]
      @cipher = OpenSSL::Cipher::AES.new(cipher_type, :CBC)
    end

    def random_iv(size = SIZE)
      Crypto::AES.random_iv(size)
    end

    def encrypt(args)
      validate_args(args)
      cipher.encrypt
      cipher.key = args[:key]
      cipher.iv = args[:iv]
      encrypted_data = cipher.update(args[:data]) + cipher.final
      Encrypted.new(encrypted_data)
    end

    def decrypt(args)
      validate_args(args)
      cipher.decrypt
      cipher.key = args[:key]
      cipher.iv = args[:iv]
      cipher.update(args[:data]) + cipher.final
    end

    private

    def validate_args(args)
      keys = args.keys
      require_args.each do |a|
        unless keys.include?(a)
          raise ArgumentError, "Expected keys #{require_args}"
        end
      end
    end
  end

  class Encrypted < Crypto::Response
    def to_str
      data
    end
  end
end
