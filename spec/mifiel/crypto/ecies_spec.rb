describe Mifiel::Crypto::ECIES do
  ecies_fixture = JSON.parse(File.read('spec/fixtures/ecies.json'), symbolize_names: true)

  describe '#ECIES' do
    ecies_fixture[:valid].each do |v|
      let(:ecies) { Mifiel::Crypto::ECIES.new }
      describe 'Encrypt & Decrypt' do
        let(:pub) { Mifiel::Crypto::ECIES.public_from_hex(v[:publicKey]) }
        let(:priv) { Mifiel::Crypto::ECIES.private_from_hex(v[:privateKey]) }
        let(:data) { v[:encryptedData] }
        let(:enc_message) { (data[:iv] + data[:ephemPublicKey] + data[:ciphertext] + data[:mac]).htb }
        let(:encrypted_data) { ecies.encrypt(pub, v[:decrypted]) }
        it "should ecnrypt #{v[:decrypted]}" do
          expect(encrypted_data).to be_a String
        end
        it "should decrypt #{v[:encryptedData].values.join('')}, to #{v[:decrypted]}" do
          expect(ecies.decrypt(priv, enc_message)).to eq(v[:decrypted])
          expect(ecies.decrypt(priv, encrypted_data)).to eq(v[:decrypted])
        end

        it 'Should raise Mifiel::ECError on bad mac' do
          bad_mac = data[:mac].clone.tr('a', 'b')
          enc_message = (data[:iv] + data[:ephemPublicKey] + data[:ciphertext] + bad_mac).htb
          expect { ecies.decrypt(priv, enc_message) }.to raise_error(Mifiel::ECError, 'Invalid mac')
        end

        it 'Should raise Mifiel::Error on short encrypted_message' do
          expect { ecies.decrypt(priv, enc_message.byteslice(0, 1)) }.to raise_error(Mifiel::ECError, 'Encrypted message too short')
        end
      end
    end
    it 'Supports hex-encoded keys' do
      key = OpenSSL::PKey::EC.new('secp256k1').generate_key
      public_key_hex = key.public_key.to_bn.to_s(16)
      private_key_hex = key.private_key.to_s(16)

      public_key = Mifiel::Crypto::ECIES.public_from_hex(public_key_hex)
      private_key = Mifiel::Crypto::ECIES.private_from_hex(private_key_hex)

      expect(public_key.public_key).to eq key.public_key
      expect(private_key.private_key).to eq key.private_key

      expect { Mifiel::Crypto::ECIES.public_from_hex(public_key_hex, 'secp224k1') }.to raise_error(OpenSSL::PKey::EC::Point::Error)
      expect { Mifiel::Crypto::ECIES.private_from_hex(private_key_hex, 'secp224k1') }.to raise_error(Mifiel::ECError)
      expect { Mifiel::Crypto::ECIES.private_from_hex('00') }.to raise_error(Mifiel::ECError)
    end
  end

  describe '#Cipher Erros' do
    it 'Raises on unknown cipher or digest' do
      expect { Mifiel::Crypto::ECIES.new(kdf_digest: 'foo') }.to raise_error(Mifiel::ECError)
      expect { Mifiel::Crypto::ECIES.new(mac_digest: 'md5') }.to raise_error(Mifiel::ECError)
      expect { Mifiel::Crypto::ECIES.new(cipher: 'aes-256-gcm') }.to raise_error(Mifiel::ECError)
    end
  end
end
