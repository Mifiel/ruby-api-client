module Mifiel
  module Crypto
    autoload :PBE, 'mifiel/crypto/pbe'
    autoload :Response, 'mifiel/crypto/response'
    autoload :AES, 'mifiel/crypto/aes'
    autoload :ECIES, 'mifiel/crypto/ecies'
    autoload :PKCS5, 'mifiel/crypto/pkcs5'
  end
end

class String
  def bth
    unpack('H*').first
  end

  def htb
    Array(self).pack('H*')
  end

  def force_binary
    return htb if match?(/^[0-9A-F]+$/i)
    return self if bth.match?(/^[0-9A-F]+$/i)
    raise ArgumentError, 'Invalid encoding, hex or binary'
  end
end
