describe Mifiel::Crypto::AES do
  aes_fixture = JSON.parse(File.read('spec/fixtures/aes.json'), symbolize_names: true)

  describe '#AES' do
    aes_fixture[:valid].each do |v|
      describe v.slice(:algorithm, :key, :dataToEncrypt).to_s do
        e_args = { data: v[:dataToEncrypt], key: v[:key], iv: v[:iv] }
        d_args = e_args.clone
        let(:aes) { Mifiel::Crypto::AES.new(v[:algorithm]) }
        let!(:encrypted) { aes.encrypt(e_args) }
        it 'should return Encrypted instance' do
          expect(encrypted).to be_a Mifiel::Crypto::Encrypted
        end
        it 'should return encrypted hex' do
          expect(encrypted.to_hex).to eq(v[:encrypted])
        end
        it 'should receive binary data and return decipher text' do
          d_args[:data] = encrypted.data
          expect(aes.decrypt(d_args)).to eq(v[:dataToEncrypt])
        end
        it 'should receive Encrypted instance & return decipher text' do
          d_args[:data] = encrypted
          expect(aes.decrypt(d_args)).to eq(v[:dataToEncrypt])
        end
        it 'should encrypt & decrypt with static method' do
          # Cipher algorithm should be included in this params, default is 256
          static_args = e_args.clone
          static_args[:cipher] = v[:algorithm]
          encrypted_data = Mifiel::Crypto::AES.encrypt(static_args)
          expect(encrypted_data == encrypted).to be true
          expect(encrypted_data.to_hex).to eq(v[:encrypted])
          static_args[:data] = encrypted_data
          expect(Mifiel::Crypto::AES.decrypt(static_args)).to eq(v[:dataToEncrypt])
        end
      end
    end

    describe 'Generate random iv' do
      let(:ivs) { Set.new }
      5.times do
        iv = Mifiel::Crypto::AES.random_iv.unpack('H*').first
        it "should be unique #{iv}" do
          expect(ivs.include?(iv)).to be false
          ivs.add(iv)
        end
      end
    end
  end
end
