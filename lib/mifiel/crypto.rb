module Mifiel::Crypto
  autoload :PBE, 'mifiel/crypto/pbe'
  autoload :Response, 'mifiel/crypto/response'
  autoload :AES, 'mifiel/crypto/aes'
  autoload :ECIES, 'mifiel/crypto/ecies'
end

class String
  def bth
    self.unpack('H*').first
  end

  def htb
    Array(self).pack('H*')
  end
end

