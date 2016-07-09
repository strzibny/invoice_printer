require 'invoice_printer/document'

module InvoicePrinter
  class Document
    # Line items for InvoicePrinter::Document
    #
    # Example:
    #
    #  item = InvoicePrinter::Document::Item.new(
    #    name: 'UX consultation',
    #    quantity: '4',
    #    unit: 'hours',
    #    price: '$ 25',
    #    tax: '$ 5'
    #    amount: '$ 120'
    #  )
    #
    # +amount+ should equal the +quantity+ times +price+,
    # but this is not enforced.
    class Item
      attr_reader :name,
                  :quantity,
                  :unit,
                  :price,
                  :tax,
                  :tax2,
                  :tax3,
                  :amount

      def self.from_json(json)
        args = Helpers.symbolize_keys(JSON(json))
        self.new(**args)
      end

      def initialize(name: nil,
                     quantity: nil,
                     unit: nil,
                     price: nil,
                     tax: nil,
                     tax2: nil,
                     tax3: nil,
                     amount: nil)
        @name = String(name)
        @quantity = String(quantity)
        @unit = String(unit)
        @price = String(price)
        @tax = String(tax)
        @tax2 = String(tax2)
        @tax3 = String(tax3)
        @amount = String(amount)
      end

      def to_h
        {
          'name': @name,
          'quantity': @quantity,
          'unit': @unit,
          'price': @price,
          'tax': @tax,
          'tax2': @tax,
          'tax3': @tax3,
          'amount': @amount
        }
      end

      def to_json
        to_h.to_json
      end
    end
  end
end
