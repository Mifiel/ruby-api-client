describe Mifiel::Document do
  let!(:certificate) { File.read('spec/fixtures/FIEL_AAA010101AAA.cer') }
  let!(:private_key) { File.read('spec/fixtures/FIEL_AAA010101AAA.key') }
  let!(:private_key_pass) { '12345678a' }

  describe '#create' do
    context 'with a document' do
      let(:document) do
        Mifiel::Document.create(
          file: 'spec/fixtures/example.pdf',
          signatories: [
            { name: 'Signer 1', email: 'signer1@email.com', tax_id: 'AAA010101AAA' },
            { name: 'Signer 2', email: 'signer2@email.com', tax_id: 'AAA010102AAA' }
          ]
        )
      end

      it { expect(document).to be_a(Hash) }
    end
  end

  describe 'working with a document' do
    let!(:document) { Mifiel::Document.all.first }

    describe '#save_file' do
      let!(:path) {'tmp/the-file.pdf' }
      before { File.unlink(path) if File.exist?(path)}

      it 'should get the file' do
        document.save_file(path)
        expect(File.exist?(path)).to be true
      end
    end

    describe '#save_file_signed' do
      let!(:path) {'tmp/the-file-signed.pdf' }
      before { File.unlink(path) if File.exist?(path)}

      it 'should get the file' do
        document.save_file_signed(path)
        expect(File.exist?(path)).to be true
      end
    end

    describe '#save_xml' do
      let!(:path) {'tmp/the-xml.xml' }
      before { File.unlink(path) if File.exist?(path)}

      it 'should get the file' do
        document.save_xml(path)
        expect(File.exist?(path)).to be true
      end
    end

    describe '#request_signature' do
      let!(:error_body) { { errors: ['some error'] }.to_json }

      it '' do
        expect do
          document.request_signature('some@email.com')
        end.not_to raise_error
      end

      context 'when bad request' do
        before do
          url = %r{mifiel.com\/api\/v1\/documents\/#{document.id}\/request_signature}
          stub_request(:post, url).to_return(body: error_body, status: 404)
        end

        it '' do
          expect do
            document.request_signature('some@email.com')
          end.to raise_error(Mifiel::BadRequestError)
        end
      end

      context 'when server error' do
        before do
          url = %r{mifiel.com\/api\/v1\/documents\/#{document.id}\/request_signature}
          stub_request(:post, url).to_return(body: error_body, status: 500)
        end

        it '' do
          expect do
            document.request_signature('some@email.com')
          end.to raise_error(Mifiel::ServerError)
        end
      end
    end
  end
end
