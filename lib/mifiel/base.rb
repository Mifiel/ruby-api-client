module Mifiel
  class Base < ActiveRestClient::Base
    after_request :rescue_errors

    def rescue_errors(name, response)
      if response.status == 400 # bad request
        result = JSON.load(response.body)
        message = result['errors'] || [result['error']]
        raise BadRequestError, message.to_a.join(', ')
      elsif (500..599).include?(response.status)
        raise ServerError, 'Server could not process request'
      end
    end

  end
end
