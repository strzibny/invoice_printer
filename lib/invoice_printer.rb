require 'invoice_printer/version'
require 'invoice_printer/document/item'
require 'invoice_printer/pdf_document'

# Create PDF versions of invoices or receipts using Prawn
#
# Example:
#
#   invoice = InvoicePrinter::Document.new(...)
#   InvoicePrinter.print(invoice, 'invoice.pdf')
module InvoicePrinter
  # Override default English labels with a given hash
  #
  # Example:
  #
  #   InvoicePrinter.labels = {
  #     name: 'Invoice',
  #     number: '201604030001'
  #     provider: 'Provider',
  #     purchaser: 'Purchaser',
  #     payment: 'Payment',
  #     payment_by_transfer: 'Payment by bank transfer on the account below:',
  #     payment_in_cash: 'Payment in cash',
  #     account_number: 'Account NO:',
  #     swift: 'SWIFT:',
  #     iban: 'IBAN:',
  #     issue_date: 'Issue date:',
  #     due_date: 'Due date:',
  #     item: 'Item',
  #     quantity: 'Quantity',
  #     unit: 'Unit',
  #     price_per_item: 'Price per item',
  #     amount: 'Amount'
  #   }
  def self.labels=(labels)
    PDFDocument.labels = labels
  end

  # Print the given InvoicePrinter::Document to PDF file named +file_name+
  def self.print(document:, file_name:, labels: {})
    PDFDocument.new(document: document, labels: labels).print(file_name)
  end

  # Render the PDF document InvoicePrinter::Document to PDF directly
  def self.render(document:, labels: {})
    PDFDocument.new(document: document, labels: labels).render
  end
end
