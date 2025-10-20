#!/usr/bin/env ruby
# Example demonstrating adding a QR image to the invoice (bottom-right)

lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'invoice_printer'

provider_address = <<ADDRESS
5th Avenue
747 05  NYC
ADDRESS

purchaser_address = <<ADDRESS
7th Avenue
747 70  NYC
ADDRESS

item = InvoicePrinter::Document::Item.new(
  name: 'Programming',
  quantity: '10',
  unit: 'hr',
  price: '$ 90',
  amount: '$ 900'
)

invoice = InvoicePrinter::Document.new(
  number: 'NO. 202500000001',
  provider_name: 'John White',
  provider_lines: provider_address,
  purchaser_name: 'Will Black',
  purchaser_lines: purchaser_address,
  issue_date: '10/20/2025',
  due_date: '11/03/2025',
  total: '$ 900',
  bank_account_number: '156546546465',
  description: "Invoice with QR image example.",
  items: [item],
  note: "Scan the QR code for payment or details."
)

qr_path = File.expand_path('../qr.png', __FILE__)
logo_path = File.expand_path('../prawn.png', __FILE__)

InvoicePrinter.print(
  document: invoice,
  logo: logo_path,
  qr: qr_path,
  file_name: 'qr_invoice.pdf'
)

InvoicePrinter.print(
  document: invoice,
  logo: logo_path,
  qr: qr_path,
  file_name: 'qr_invoice_a4.pdf',
  page_size: :a4
)
