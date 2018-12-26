module CoreExtensions
  module String
    module BinaryHex
      def bth
        unpack('H*').first
      end

      def htb
        Array(self).pack('H*')
      end

      def force_binary
        return htb if match(/^[0-9A-F]+$/i).is_a? MatchData
        return self if bth.match(/^[0-9A-F]+$/i).is_a? MatchData
        raise ArgumentError, 'Invalid encoding, hex or binary'
      end
    end
  end
end
