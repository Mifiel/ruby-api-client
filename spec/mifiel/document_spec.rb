# frozen_string_literal: true

describe Mifiel::Document do
  let(:certificate) { File.read('spec/fixtures/FIEL_AAA010101AAA.cer') }
  let(:private_key) { File.read('spec/fixtures/FIEL_AAA010101AAA.key') }
  let(:private_key_pass) { '12345678a' }

  describe '#create' do
    context 'with a document' do
      let(:document) do
        described_class.create(
          file: 'spec/fixtures/example.pdf',
          signatories: [
            { name: 'Signer 1', email: 'signer1@email.com', tax_id: 'AAA010101AAA' },
            { name: 'Signer 2', email: 'signer2@email.com', tax_id: 'AAA010102AAA' },
          ],
        )
      end

      it { expect(document).to be_a(described_class) }
    end

    describe 'from template' do
      let!(:template_id) { 'c6c29866-7fd6-4f77-9ecd-eae8bc3a772a' }
      let!(:document) do
        described_class.create_from_template(
          template_id: template_id,
          fields: {
            name: 'some',
          },
          signatories: [{
            name: 'Signer',
            email: 'signer@email.com',
          }, {
            name: 'Signer',
            email: 'signer@email.com',
          },],
        )
      end

      it { expect(document).to be_a described_class }
    end

    describe 'many from template' do
      let!(:template_id) { 'c6c29866-7fd6-4f77-9ecd-eae8bc3a772a' }
      let!(:documents) do
        described_class.create_many_from_template(
          template_id: template_id,
          callback_url: 'http://some-callback.url/mifiel',
          identifier: 'name',
          documents: [{
            fields: {
              name: 'Some Name',
            },
            signatories: [{
              name: 'Signer',
              email: 'signer@email.com',
            }, {
              name: 'Signer',
              email: 'signer@email.com',
            },],
          }],
        )
      end

      it { expect(documents.status).to eq 'success' }
    end
  end

  describe 'working with a document' do
    let!(:document) { described_class.all.first }

    describe '#raw_file' do
      let(:document_content) { 'some-pdf-formatted-string' }

      it 'gets the file raw data' do
        expect(document.raw_file).to eq document_content
      end
    end

    describe '#raw_file_signed' do
      let(:document_content) { 'some-pdf-formatted-string' }

      it 'gets the file raw signed data' do
        expect(document.raw_file_signed).to eq document_content
      end
    end

    describe '#save_file' do
      let!(:path) { 'tmp/the-file.pdf' }

      before { FileUtils.rm_f(path) }

      it 'gets the file' do
        document.save_file(path)
        expect(File.exist?(path)).to be true
      end
    end

    describe '#save_file_signed' do
      let!(:path) { 'tmp/the-file-signed.pdf' }

      before { FileUtils.rm_f(path) }

      it 'gets the file' do
        document.save_file_signed(path)
        expect(File.exist?(path)).to be true
      end
    end

    describe '#save_xml' do
      let!(:path) { 'tmp/the-xml.xml' }

      before { FileUtils.rm_f(path) }

      it 'gets the file' do
        document.save_xml(path)
        expect(File.exist?(path)).to be true
      end
    end

    describe '#request_signature' do
      let!(:error_body) { { errors: ['some error'] }.to_json }

      it do
        expect do
          document.request_signature('some@email.com')
        end.not_to raise_error
      end

      context 'when bad request' do
        before do
          url = %r{mifiel.com/api/v1/documents/#{document.id}/request_signature}
          stub_request(:post, url).to_return(body: error_body, status: 404)
        end

        it do
          expect do
            document.request_signature('some@email.com')
          end.to raise_error(Mifiel::BadRequestError)
        end
      end

      context 'when server error' do
        before do
          url = %r{mifiel.com/api/v1/documents/#{document.id}/request_signature}
          stub_request(:post, url).to_return(body: error_body, status: 500)
        end

        it do
          expect do
            document.request_signature('some@email.com')
          end.to raise_error(Mifiel::ServerError)
        end
      end
    end
  end
end
