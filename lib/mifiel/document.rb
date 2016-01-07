module Mifiel
  class Document < Mifiel::Base

    get :all, '/documents'
    get :find, '/documents/:id'
    put :save, '/documents/:id'
    post :create, '/documents'

  end

end
