require 'openssl'
require 'securerandom'

module Mifiel
  module Crypto
    class PBE
      ALPHA_NUM = ('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a
      SPECIALS = ['-', '_', '+', '=', '#', '&', '*', '.'].freeze
      CHARS = ALPHA_NUM + SPECIALS
      ITERATIONS = 1000

      def self.random_password(length = 32)
        CHARS.sort_by { SecureRandom.random_number }.join[0...length]
      end

      def self.random_salt(size = 16)
        SecureRandom.random_bytes(size)
      end

      def self.derive_key(password:, salt:, key_size: 32, iterations: ITERATIONS)
        args = {
          password: password,
          salt: salt,
          iterations: iterations,
          key_size: key_size,
          digest: OpenSSL::Digest::SHA256.new
        }
        OpenSSL::PKCS5.pbkdf2_hmac(*args.values)
      rescue => e
        raise Mifiel::PBError, e.message || 'Unable to derive key.'
      end
    end
  end
end
