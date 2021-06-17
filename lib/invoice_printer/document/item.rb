module InvoicePrinter
  class Document
    # Line items for InvoicePrinter::Document
    #
    # Example:
    #
    #  item = InvoicePrinter::Document::Item.new(
    #    name: 'UX consultation',
    #    breakdown: "Monday 3h\nTuesday 1h"
    #    variable: 'June 2008',
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
                  :breakdown,
                  :variable, # for anything required
                  :quantity,
                  :unit,
                  :price,
                  :tax,
                  :tax2,
                  :tax3,
                  :amount

      class << self
        def from_json(json)
          new(
            name: json['name'],
            breakdown: json['breakdown'],
            variable: json['variable'],
            quantity: json['quantity'],
            unit: json['unit'],
            price: json['price'],
            tax: json['tax'],
            tax2: json['tax2'],
            tax3: json['tax3'],
            amount: json['amount']
          )
        end
      end

      def initialize(name: nil,
                     breakdown: nil,
                     variable: nil,
                     quantity: nil,
                     unit: nil,
                     price: nil,
                     tax: nil,
                     tax2: nil,
                     tax3: nil,
                     amount: nil)

        @name = String(name)
        @breakdown = String(breakdown)
        @variable = String(variable)
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
          'breakdown': @breakdown,
          'variable': @variable,
          'quantity': @quantity,
          'unit': @unit,
          'price': @price,
          'tax': @tax,
          'tax2': @tax2,
          'tax3': @tax3,
          'amount': @amount,
        }
      end

      def to_json
        to_h.to_json
      end
    end
  end
end
