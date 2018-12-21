module Mifiel
  module Crypto
    class PKCS5
      DIGEST = 'hmacWithSHA256'.freeze
      CIPHERS = { 16 => 'AES-128-CBC', 24 => 'AES-192-CBC', 32 => 'AES-256-CBC' }.freeze

       def self.parse(der)
         reader = Reader.new(der)
         PKCS5.new(reader.values).tap { |pk| pk.instance_variable_set('@asn1', reader.asn1) }
       end

       attr_reader :size_key, :cipher_text, :salt, :iv, :cipher, :iterations

      def initialize(iv:, salt:, cipher_text:, iterations:, size_key: 32)
        @cipher_text = cipher_text.force_binary
        @size_key = size_key
        @salt = salt.force_binary
        @iv = iv.force_binary
        @iterations = iterations
      end
      # rubocop:disable all
      def asn1 
        @asn1 ||= OpenSSL::ASN1::Sequence.new([
      		OpenSSL::ASN1::Sequence.new([
      			OpenSSL::ASN1::ObjectId.new('PBES2'), 
      			OpenSSL::ASN1::Sequence.new([
      				OpenSSL::ASN1::Sequence.new([ 
      					OpenSSL::ASN1::ObjectId.new('PBKDF2'), 
      					OpenSSL::ASN1::Sequence.new([
      						OpenSSL::ASN1::OctetString.new(salt), 
      						OpenSSL::ASN1::Integer.new(OpenSSL::BN.new(iterations)), 
      						OpenSSL::ASN1::Sequence.new([OpenSSL::ASN1::ObjectId.new('hmacWithSHA256')])
      					])
      				]), 
      				OpenSSL::ASN1::Sequence.new([
      					OpenSSL::ASN1::ObjectId.new(cipher_id(size_key)),
      					OpenSSL::ASN1::OctetString.new(iv)
      				])
      			])
      		]), 
      		OpenSSL::ASN1::OctetString.new(cipher_text)
      	])
      end

      # rubocop:enable all
      def ==(other)
        return to_der == other if other.is_a?(String)
        to_der == other.to_der
      end

      def to_der
        asn1.to_der
      end

      def to_hex
        to_der.bth
      end

      private

      def cipher_id(size_key)
        raise Mifiel::PKCS5Error, 'Key len not supported' unless CIPHERS[size_key]
        CIPHERS[size_key]
      end

      class Reader
        attr_reader :asn1

        def initialize(der)
          @asn1 = OpenSSL::ASN1.decode(der.force_binary)
          raise Mifiel::PKCS5Error, 'Digest algorithm not supported' unless digest == DIGEST
          raise Mifiel::PKCS5Error, 'Encryption algorithm not supported' unless CIPHERS.values.include?(cipher)
        rescue OpenSSL::ASN1::ASN1Error => e
          if e.message == 'Type mismatch. Total bytes read: 8 Bytes available: 1298 Offset: 8'
            raise Mifiel::PKCS5Error, 'Exception decoding bytes: Bytes are not PKCS5'
          end
          raise Mifiel::PKCS5Error, 'Unable to read data'
        end

        def values
          {
            cipher_text: cipher_text,
            salt: salt,
            iv: iv,
            size_key: size_key,
            iterations: iterations
          }
        end

        def cipher_text
          @cipher_text ||= fetch_asn1(1).value
        end

        def salt
          @salt ||= fetch_asn1(0, 1, 0, 1, 0).value
        end

        def iv
          @iv ||= fetch_asn1(0, 1, 1, 1).value
        end

        def cipher
          @cipher ||= fetch_asn1(0, 1, 1, 0).value
        end

        def digest
          @digest ||= fetch_asn1(0, 1, 0, 1, 2, 0).value
        end

        def iterations
          @iterations ||= fetch_asn1(0, 1, 0, 1, 1).value.to_i
        end

        def size_key
          CIPHERS.to_a.map { |a, b| [b, a] }.to_h[cipher]
        end

        # Fetch the ASN1 for a specific index
        # @param asn1 [ASN1] The asn1 where to fetch the data
        # @param *arr [Args] indexes
        # @example
        #   fetch_asn1(0, 1, 0) # to_asn1.value[0].value[1].value[0]
        # @return [ASN1]
        def fetch_asn1(*arr)
          value = asn1
          arr.each { |index| value = value.value[index] }
          value
        end
      end
    end
  end
end
