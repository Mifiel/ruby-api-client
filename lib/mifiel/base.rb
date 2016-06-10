require 'rest-client'

module Mifiel
  class Base < ActiveRestClient::Base
    after_request :rescue_errors

    def rescue_errors(_name, response)
      if response.status == 400 # bad request
        result = JSON.load(response.body)
        message = result['errors'] || [result['error']]
        raise BadRequestError, message.to_a.join(', ')
      elsif (500..599).cover?(response.status)
        raise ServerError, "Could not process your request: status #{response.status}"
      end
    end
  end
end
