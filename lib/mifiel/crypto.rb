module Mifiel
  module Crypto
    autoload :PBE, 'mifiel/crypto/pbe'
    autoload :Response, 'mifiel/crypto/response'
    autoload :AES, 'mifiel/crypto/aes'
    autoload :ECIES, 'mifiel/crypto/ecies'
  end
end

class String
  def bth
    unpack('H*').first
  end

  def htb
    Array(self).pack('H*')
  end
end
