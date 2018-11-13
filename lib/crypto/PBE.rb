
require 'openssl'
require 'securerandom'

module Crypto
  class PBE
    alpha_num = ('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a
    specials = ['-', '_', '+', '=', '#', '&', '*', '.']
    CHARS = alpha_num + specials

    def initialize(i = 1000)
      @iterations = i
      @digest = OpenSSL::Digest::SHA256.new
    end

    def random_password(length=32)
      CHARS.sort_by { SecureRandom.random_number }.join[0...length]
    end

    def random_salt(size = 16)
      SecureRandom.random_bytes(size)
    end

    def derived_key(password, salt, sizeKey = 24)
      OpenSSL::PKCS5.pbkdf2_hmac(password, salt, @iterations, sizeKey, @digest)
    end
  end
end
