describe Mifiel::Crypto::PKCS5 do
  pkcs5_fixture = JSON.parse(File.read('spec/fixtures/pkcs5.json'), symbolize_names: true)
  let(:salt) { 'e6acc0e2db992976bf4cbaae6bcd5749' }
  let(:iv) { 'c5a3576faed910ad804b07aec9ebf70e' }
  let(:encrypted_text) { '3453091b7f8b4b76aba751f8cea225d3438418467711f46f3506960a55a2ac28' }
  der_hex = '308181305d06092a864886f70d01050d3050302f06092a864886f70d01050c3022'\
    '0410e6acc0e2db992976bf4cbaae6bcd5749020207d0300a06082a864886f70d02'\
    '09301d060960864801650304012a0410c5a3576faed910ad804b07aec9ebf70e04'\
    '203453091b7f8b4b76aba751f8cea225d3438418467711f46f3506960a55a2ac28'

  describe '#PKCS5 valid' do
    pkcs5_fixture[:valid].each do |v|
      describe "ASN1: #{v[:asn1]}" do
        let(:asn1) { v[:asn1] }
        it 'should read asn1 encoding' do
          pkcs5 = Mifiel::Crypto::PKCS5.parse(asn1)
          expect(pkcs5).to be_a Mifiel::Crypto::PKCS5
          expect(pkcs5.to_der).to eq(asn1.htb)
          expect(pkcs5.to_hex).to eq(asn1)
        end
      end
    end

    it 'Should build asn1 encoding' do
      pkcs5 = Mifiel::Crypto::PKCS5.new(iv: iv, salt: salt, cipher_text: encrypted_text, iterations: 2000)
      pkcs5_read = Mifiel::Crypto::PKCS5.parse(pkcs5.to_der)
      pkcs5_read2 = Mifiel::Crypto::PKCS5.parse(pkcs5_fixture[:valid].first[:asn1])
      expect(pkcs5.asn1).to be_a OpenSSL::ASN1::Sequence
      expect(pkcs5.to_der).to eq(der_hex.htb)
      expect(pkcs5.to_hex).to eq(der_hex)
      expect(pkcs5 == pkcs5_read).to be true
      expect(pkcs5 == pkcs5_read2).to be false
    end
  end

  describe '#PKCS5 invalid' do
    pkcs5_fixture[:invalid].each do |v|
      describe "ASN1: #{v[:asn1]}" do
        let(:asn1) { v[:asn1] }
        it "should raise #{v[:error]}" do
          expect { Mifiel::Crypto::PKCS5.parse(asn1) }.to raise_error Mifiel::PKCS5Error, v[:error]
        end
      end
    end
  end
end
