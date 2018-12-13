# This class was based on https://github.com/jamoes/ecies
module Mifiel
  module Crypto
    class ECIES
      # The allowed digest algorithms for ECIES.
      DIGESTS = %w(SHA224 SHA256 SHA384 SHA512).freeze

      # The allowed cipher algorithms for ECIES.
      CIPHERS = %w(AES-128-CBC AES-192-CBC AES-256-CBC).freeze
      IV_SIZE = 16

      def initialize(cipher: 'AES-256-CBC', kdf_digest: 'SHA512', mac_digest: 'SHA256')
        raise Mifiel::ECError, "Cipher must be one of #{CIPHERS}"  unless CIPHERS.include?(cipher)
        raise Mifiel::ECError, "Cipher must be one of #{DIGESTS}"  unless DIGESTS.include?(mac_digest)
        raise Mifiel::ECError, "Cipher must be one of #{DIGESTS}"  unless DIGESTS.include?(kdf_digest)

        @cipher = OpenSSL::Cipher.new(cipher)
        @mac_digest = OpenSSL::Digest.new(mac_digest)
        @kdf_digest = OpenSSL::Digest.new(kdf_digest)
        @mac_length = @mac_digest.digest_length
      end

      def cipher_final(key, iv, message, action: :encrypt)
        @cipher.reset
        @cipher.send(action)
        @cipher.iv = iv
        @cipher.key = key
        @cipher.update(message) + @cipher.final
      end

      def generate_keys(shared_secret)
        key_pair = @kdf_digest.digest(shared_secret)
        cipher_key = key_pair.byteslice(0, @cipher.key_len)
        hmac_key = key_pair.byteslice(-@mac_length, @mac_length)
        { cipher_key: cipher_key, hmac_key: hmac_key }
      end

      def compute_mac(hmac_key, ephemeral_public_key_octet, ciphertext, iv)
        OpenSSL::HMAC.digest(@mac_digest, hmac_key, iv + ephemeral_public_key_octet + ciphertext)
      end

      # Encrypts a message to a public key using ECIES.
      # @param key [OpenSSL::EC:PKey] The public key.
      # @param message [String] The plain-text message.
      # @return [String] The octet string of the encrypted message.
      def encrypt(key, message, iv: nil) # rubocop:disable Metrics/AbcSize
        iv ||= OpenSSL::Random.random_bytes(IV_SIZE)
        ephemeral_key = OpenSSL::PKey::EC.new(key.group).generate_key
        ephemeral_public_key_octet = ephemeral_key.public_key.to_bn.to_s(2)
        keys = generate_keys(ephemeral_key.dh_compute_key(key.public_key))

        ciphertext = cipher_final(keys[:cipher_key], iv, message)
        mac = compute_mac(keys[:hmac_key], ephemeral_public_key_octet, ciphertext, iv)
        iv + ephemeral_public_key_octet + ciphertext + mac
      end

      # Decrypts a message with a private key using ECIES.
      # @param key [OpenSSL::EC:PKey] The private key.
      # @param encrypted_message [String] Octet string of the encrypted message.
      # @return [String] The plain-text message.
      def decrypt(key, encrypted_message) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        iv = encrypted_message.byteslice(0, IV_SIZE)
        group_copy = OpenSSL::PKey::EC::Group.new(key.group)
        ephemeral_public_key_length = group_copy.generator.to_bn.to_s(2).bytesize
        ciphertext_length = encrypted_message.bytesize - ephemeral_public_key_length - @mac_length - IV_SIZE
        raise Mifiel::ECError, 'Encrypted message too short' unless ciphertext_length > 0

        ephemeral_public_key_octet = encrypted_message.byteslice(iv.bytesize, ephemeral_public_key_length)
        ciphertext = encrypted_message.byteslice((ephemeral_public_key_length + iv.bytesize), ciphertext_length)
        ephemeral_public_key = OpenSSL::PKey::EC::Point.new(group_copy, OpenSSL::BN.new(ephemeral_public_key_octet, 2))
        keys = generate_keys(key.dh_compute_key(ephemeral_public_key))

        mac = encrypted_message.byteslice(-@mac_length, @mac_length)
        computed_mac = compute_mac(keys[:hmac_key], ephemeral_public_key_octet, ciphertext, iv)
        raise Mifiel::ECError, 'Invalid mac' unless computed_mac == mac
        cipher_final(keys[:cipher_key], iv, ciphertext, action: :decrypt)
      end

      # Converts a hex-encoded public key to an `OpenSSL::PKey::EC`.
      #
      # @param hex_string [String] The hex-encoded public key.
      # @param ec_group [OpenSSL::PKey::EC::Group,String] The elliptical curve
      #     group for this public key.
      # @return [OpenSSL::PKey::EC] The public key.
      # @raise [OpenSSL::PKey::EC::Point::Error] If the public key is invalid.
      def self.public_from_hex(hex_string, ec_group = 'secp256k1')
        ec_group = OpenSSL::PKey::EC::Group.new(ec_group) if ec_group.is_a?(String)
        key = OpenSSL::PKey::EC.new(ec_group)
        key.public_key = OpenSSL::PKey::EC::Point.new(ec_group, OpenSSL::BN.new(hex_string, 16))
        key
      end

      # Converts a hex-encoded private key to an `OpenSSL::PKey::EC`.
      #
      # @param hex_string [String] The hex-encoded private key.
      # @param ec_group [OpenSSL::PKey::EC::Group,String] The elliptical curve
      #     group for this private key.
      # @return [OpenSSL::PKey::EC] The private key.
      # @note The returned key only contains the private component. In order to
      #     populate the public component of the key, you must compute it as
      #     follows: `key.public_key = key.group.generator.mul(key.private_key)`.
      # @raise [::ECError] If the private key is invalid.
      def self.private_from_hex(hex_string, ec_group = 'secp256k1')
        ec_group = OpenSSL::PKey::EC::Group.new(ec_group) if ec_group.is_a?(String)
        key = OpenSSL::PKey::EC.new(ec_group)
        key.private_key = OpenSSL::BN.new(hex_string, 16)
        raise Mifiel::ECError, 'Private key greater than group order' unless key.private_key < ec_group.order
        raise Mifiel::ECError, 'Private key too small' unless key.private_key > 1
        key
      end
    end
  end
end
