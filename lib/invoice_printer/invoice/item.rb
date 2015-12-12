require 'invoice_printer/invoice'

module InvoicePrinter
  class Invoice::Item
    attr_accessor :name,
                  :number,
                  :unit,
                  :price,
                  :amount

    def initialize(name: nil,
                   number: nil,
                   unit: nil,
                   price: nil,
                   amount: nil)
      @name = name
      @number = number
      @unit = unit
      @price = price
      @amount = amount
    end
  end
end
