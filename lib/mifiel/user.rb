# frozen_string_literal: true

module Mifiel
  class User < Mifiel::Base
    post :setup_widget, '/users/setup-widget'
  end
end
