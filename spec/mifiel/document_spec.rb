describe Mifiel::Document do

  describe '#create' do
    context 'with a document' do
      let(:document) do
        Mifiel::Document.create(
            file: File.new('spec/fixtures/example.pdf'),
            signatories: [
              { name: 'Signer 1', email: 'signer1@email.com', rfc: 'DEFG857362UP1' },
              { name: 'Signer 2', email: 'signer2@email.com', rfc: 'DEFG857362UP2' }
            ]
          )
      end

      it { expect(document).to be_a(Hash) }
    end
  end

  describe '#sign' do
    let!(:public_key) { File.read('spec/fixtures/FIEL_AAA010101AAA.cer') }
    let!(:private_key) { File.read('spec/fixtures/FIEL_AAA010101AAA.key') }
    let!(:private_key_pass) { '12345678a' }
    let!(:signature) { 'signature' }
    let!(:document) { Mifiel::Document.find(1) }

    context 'without valid arguments' do
      it { expect{document.sign(3)}.to raise_error(Mifiel::MifielError) }
    end

    context 'with private_key but not private_key_pass' do
      it do
        expect{document.sign(3, private_key: private_key)}.to raise_error(Mifiel::MifielError)
      end
    end

    context 'with private_key and private_key_pass' do
      it do
        expect{document.sign(3, private_key: private_key, private_key_pass: private_key_pass)}.not_to raise_error
      end
    end

    context 'with signature' do
      it do
        expect{document.sign(3, signature: signature)}.not_to raise_error
      end
    end

    context 'with a wrong private_key' do
      it do
        expect{document.sign(3, private_key: 'asd', private_key_pass: private_key_pass)}.to raise_error(Mifiel::PrivateKeyError)
      end
    end

    context 'with a private_key that is not a private_key' do
      xit do
        cer = OpenSSL::X509::Certificate.new(public_key)
        expect{document.sign(3, private_key: cer.public_key.to_der, private_key_pass: private_key_pass)}.to raise_error(Mifiel::NotPrivateKeyError)
      end
    end

    context 'with a wrong password' do
      it do
        expect{document.sign(3, private_key: 'asd', private_key_pass: private_key_pass)}.to raise_error(Mifiel::PrivateKeyError)
      end
    end
  end

end
