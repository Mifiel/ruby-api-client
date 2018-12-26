module Mifiel
  MifielError = Class.new StandardError
  BadRequestError = Class.new StandardError
  ServerError = Class.new StandardError
  PrivateKeyError = Class.new StandardError
  NotPrivateKeyError = Class.new ArgumentError
  NoSignatureError = Class.new StandardError
  ECError = Class.new StandardError
  PKCS5Error = Class.new StandardError
  AESError = Class.new StandardError
  PBError = Class.new StandardError
end
