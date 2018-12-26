require_relative './core_extensions/string/binary_hex'

module CoreExtensions
  def self.load
    ::String.include CoreExtensions::String::BinaryHex
  end
end
