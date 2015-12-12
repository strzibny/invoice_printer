require 'invoice_printer/version'
require 'invoice_printer/invoice/item'
require 'invoice_printer/invoice_pdf'

module InvoicePrinter
  def self.labels=(labels)
    InvoicePDF.labels = labels
  end

  def self.print(invoice, file_name)
    InvoicePDF.new(invoice).print(file_name)
  end
end
