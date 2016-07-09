module InvoicePrinter
  # Internal helpers method
  module Helpers
    def self.symbolize_keys(obj)
      return obj.reduce({}) do |memo, (k, v)|
        memo.tap { |m| m[k.to_sym] = symbolize_keys(v) }
      end if obj.is_a? Hash

      return obj.reduce([]) do |memo, v|
        memo << symbolize_keys(v); memo
      end if obj.is_a? Array

      obj
    end
  end
end
