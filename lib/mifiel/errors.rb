# frozen_string_literal: true

module Mifiel
  class MifielError < StandardError
  end

  class BadRequestError < StandardError
  end

  class ServerError < StandardError
  end

  class PrivateKeyError < StandardError
  end

  class NotPrivateKeyError < ArgumentError
  end

  class NoSignatureError < StandardError
  end
end
