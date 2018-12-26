describe Mifiel::Crypto do
  pkcs5_fixture = JSON.parse(File.read('spec/fixtures/pkcs5.json'), symbolize_names: true)
  describe '#Crypto' do
    pkcs5_fixture[:valid].each do |v|
      describe "ASN1: #{v[:asn1]}" do
        it 'Should decrypt message' do
          decrypted = Mifiel::Crypto.decrypt(v[:asn1], v[:password])
          expect(decrypted).to eq(pkcs5_fixture[:plain_text])
        end
      end
      it "Should encrypt a document, password: #{v[:password]}" do
        pdf = File.read('spec/fixtures/example.pdf')
        encrypted = Mifiel::Crypto.encrypt(pdf, v[:password])
        encrypted_parsed = Mifiel::Crypto::PKCS5.parse(encrypted.to_der)
        expect(encrypted).to be_a Mifiel::Crypto::PKCS5
        expect(encrypted == encrypted_parsed).to be true
      end
    end
  end
end
