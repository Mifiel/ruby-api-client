require 'sinatra/base'
# rubocop:disable Metrics/ClassLength
class FakeMifiel < Sinatra::Base
  get '/api/v1/keys' do
    content_type :json
    status 200
    [
      key,
      key
    ].to_json
  end

  get '/api/v1/templates' do
    content_type :json
    status 200
    [
      template,
      template
    ].to_json
  end

  get '/api/v1/templates/:id' do
    content_type :json
    status 200
    template(id: params[:id]).to_json
  end

  post '/api/v1/templates' do
    content_type :json
    status 200
    template.to_json
  end

  post '/api/v1/templates/:id/generate_documents' do
    content_type :json
    status 200
    { status: :success }.to_json
  end

  post '/api/v1/templates/:id/generate_document' do
    content_type :json
    status 200
    document(id: params[:id]).to_json
  end

  post '/api/v1/keys' do
    content_type :json
    status 200
    key(id: params[:id]).to_json
  end

  get '/api/v1/documents' do
    content_type :json
    status 200
    [
      document,
      document
    ].to_json
  end

  post '/api/v1/documents' do
    content_type :json
    status 200
    document(
      id: params[:id],
      original_hash: Digest::SHA256.hexdigest(params[:file][:tempfile].read),
      file_file_name: params[:file][:filename],
      signed: false,
      signed_at: nil
    ).to_json
  end

  post '/api/v1/documents/:id/sign' do
    content_type :json
    status 200
    document(
      id: params[:id]
    ).to_json
  end
  

  get '/api/v1/documents/:id/file' do
    status 200
    'some-pdf-formatted-string'
  end

  get '/api/v1/documents/:id/file_signed' do
    status 200
    'some-pdf-formatted-string'
  end

  get '/api/v1/documents/:id/xml' do
    status 200
    '<some><xml>contents</xml></some>'
  end

  post '/api/v1/documents/:id/request_signature' do
    content_type :json
    status 200
    { bla: 'Correo enviado' }.to_json
  end

  post '/api/v1/users/setup-widget' do
    content_type :json
    status 200
    { widget_id: '123bc', success: true }.to_json
  end

  post '/api/v1/documents/:id/transfer' do
    content_type :json
    status 200
    document(
      id: params[:id]
    ).to_json
  end

  private

    def template(args = {})
      {
        id: args[:id] || SecureRandom.uuid,
        name: 'some-template',
        content: '<div><field name="name">NAME</field></div>'
      }
    end

    def key(args={})
      id = args[:id] || SecureRandom.uuid
      {
        id: id,
        type_of: 'FIEL',
        cer_hex: '308204cf30...1303030303030323',
        owner: 'JORGE MORALES MENDEZ',
        tax_id: 'MOMJ811012643',
        expires_at: '2017-04-28T19:43:23.000Z',
        expired: false
      }
    end

    # rubocop:disable Metrics/MethodLength
    def document(args={})
      id = args[:id] || SecureRandom.uuid
      {
        id: id,
        original_hash: Digest::SHA256.hexdigest(id),
        file_file_name: 'test-pdf.pdf',
        signed_by_all: true,
        signed: true,
        signed_at: Time.now.utc.iso8601,
        status: [1, 'Firmado'],
        owner: {
          email: 'signer1@email.com',
          name: 'Jorge Morales'
        },
        file: "/api/v1/documents/#{id}/file",
        file_download: "/api/v1/documents/#{id}/file?download=true",
        file_signed: "/api/v1/documents/#{id}/file_signed",
        file_signed_download: "/api/v1/documents/#{id}/file_signed?download=true",
        file_zipped: "/api/v1/documents/#{id}/zip",
        signatures: [{
          email: 'signer1@email.com',
          signed: true,
          signed_at: (Time.now.utc - 10_000).iso8601,
          certificate_number: '20001000000200001410',
          tax_id: 'AAA010101AAA',
          signature: '77cd5156779c..4e276ef1056c1de11b7f70bed28',
          user: {
            email: 'signer1@email.com',
            name: 'Jorge Morales'
          }
        }]
      }
    end
end
