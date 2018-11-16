require 'openssl'
require 'securerandom'

module Crypto
  class PBE
    ALPHA_NUM = ('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a
    SPECIALS = ['-', '_', '+', '=', '#', '&', '*', '.'].freeze
    CHARS = ALPHA_NUM + SPECIALS

    def self.generate
      pbe = Crypto::PBE.new
      password = pbe.random_password
      salt = pbe.random_salt
      pbe.derived_key(password, salt)
    end

    def initialize(i = 1000)
      @iterations = i
      @digest = OpenSSL::Digest::SHA256.new
    end

    def random_password(length = 32)
      CHARS.sort_by { SecureRandom.random_number }.join[0...length]
    end

    def random_salt(size = 16)
      SecureRandom.random_bytes(size)
    end

    def derived_key(password, salt, sizeKey = 24)
      args = {
        password: password,
        salt: salt,
        iterations: @iterations,
        sizeKey: sizeKey,
        digest: @digest
      }
      PKCS5.new(args)
    end
  end

  class PKCS5
    attr_reader :key

    def ==(other)
      key == other.key
    end

    def initialize(args)
      @key = OpenSSL::PKCS5.pbkdf2_hmac(*args.values)
    end

    def to_hex
      key.unpack('H*').first
    end
  end
end
