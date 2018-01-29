module Mifiel
  class Template < Mifiel::Base
    get :all, '/templates'
    get :find, '/templates/:id'
    put :save, '/templates/:id'
    post :create, '/templates'
    delete :delete, '/templates/:id'
    get :fields, '/templates/:id/fields'

    def generate_document(args = {})
      Mifiel::Document.create_from_template(args.merge(template_id: id))
    end

    def generate_documents(callback_url:, documents:, identifier: nil)
      Mifiel::Document.create_many_from_template(
        template_id: id,
        identifier: identifier,
        documents: documents,
        callback_url: callback_url
      )
    end
  end
end
