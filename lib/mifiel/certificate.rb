module Mifiel
  class Certificate < Mifiel::Base

    get :all, '/keys'
    get :find, '/keys/:id'
    put :save, '/keys/:id'
    post :create, '/keys'

  end

end
