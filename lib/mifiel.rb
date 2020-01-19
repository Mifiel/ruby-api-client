# frozen_string_literal: true

require 'flexirest'

module Mifiel
  require 'mifiel/errors'
  autoload :Base, 'mifiel/base'
  autoload :Document, 'mifiel/document'
  autoload :Certificate, 'mifiel/certificate'
  autoload :Template, 'mifiel/template'
  autoload :Config, 'mifiel/config'
  autoload :User, 'mifiel/user'

  BASE_URL = 'https://www.mifiel.com/api/v1'

  def self.config
    if block_given?
      yield(Mifiel::Config)
    else
      Mifiel::Config
    end
  end
end
