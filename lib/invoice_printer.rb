require 'invoice_printer/version'
require 'invoice_printer/document/item'
require 'invoice_printer/pdf_document'

module InvoicePrinter
  def self.labels=(labels)
    PDFDocument.labels = labels
  end

  def self.print(invoice, file_name)
    PDFDocument.new(invoice).print(file_name)
  end
end
