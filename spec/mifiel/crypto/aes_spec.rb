describe Mifiel::Crypto::AES do
  aes_fixture = JSON.parse(File.read('spec/fixtures/aes.json'), symbolize_names: true)

  describe '#AES good' do
    aes_fixture[:valid].each do |v|
      describe v.slice(:algorithm, :key, :dataToEncrypt).to_s do
        e_args = { data: v[:dataToEncrypt], key: v[:key], iv: v[:iv], cipher: v[:algorithm] }
        d_args = e_args.clone
        let(:aes) { Mifiel::Crypto::AES.new(e_args[:cipher]) }
        let(:encrypted) { aes.encrypt(e_args) }
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
          encrypted_data = Mifiel::Crypto::AES.encrypt(e_args)
          expect(encrypted_data == encrypted).to be true
          expect(encrypted_data.to_hex).to eq(v[:encrypted])
          d_args[:data] = encrypted_data
          expect(Mifiel::Crypto::AES.decrypt(d_args)).to eq(v[:dataToEncrypt])
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

  describe '#AES bad' do
    describe 'ArgumentError, sending wrong data to decrypt' do
      args = { data: 'bad-data', iv: Mifiel::Crypto::AES.random_iv, key: 'this-aSecure-key' }
      let(:expected_error) { "Expected keys #{Mifiel::Crypto::AES.new.require_args}" }
      it 'should raise expected error' do
        args = {}
        expect { Mifiel::Crypto::AES.decrypt(args) }.to raise_error(ArgumentError, expected_error)
      end
    end
  end
end
