# frozen_string_literal: true

require 'rest-client'

module Mifiel
  class Base < Flexirest::Base
    after_request :rescue_errors

    def rescue_errors(_name, response)
      case response.status
      when (400..499)
        result = JSON.parse(response.body)
        message = result['errors'] || [result['error']]
        raise BadRequestError, message.to_a.join(', ')
      when (500..599)
        raise ServerError, "Could not process your request: status #{response.status}"
      end
    end
  end
end
