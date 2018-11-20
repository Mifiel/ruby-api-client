module Crypto
  class Response
    attr_reader :data

    def ==(other)
      data == other.data
    end

    def initialize(data)
      @data = data
    end

    def to_hex
      data.unpack('H*').first
    end
  end
end
