module Mifiel
  MifielError = Class.new StandardError
  BadRequestError = Class.new StandardError
  ServerError = Class.new StandardError
  PrivateKeyError = Class.new StandardError
  NotPrivateKeyError = Class.new ArgumentError
  NoSignatureError = Class.new StandardError
end
