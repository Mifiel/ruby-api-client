# frozen_string_literal: true

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

    def self.process_request(path, mthd, payload: nil, type: false)
      url = "#{Mifiel.config.base_url}/#{path.gsub(%r{^/}, '')}"
      options = { request_body_type: type }
      options[:plain] = true if type == :plain
      _request(
        url,
        mthd,
        payload,
        options,
      )
    end
  end
end
