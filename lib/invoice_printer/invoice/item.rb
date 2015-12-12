require 'invoice_printer/invoice'

module InvoicePrinter
  class Invoice::Item
    attr_accessor :name,
                  :number,
                  :unit,
                  :price,
                  :amount
  end
end