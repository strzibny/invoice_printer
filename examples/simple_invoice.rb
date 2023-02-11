#!/usr/bin/env ruby
# This is an example of a very simple invoice.

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
  number: 'NO. 198900000001',
  provider_name: 'John White',
  provider_lines: provider_address,
  purchaser_name: 'Will Black',
  purchaser_lines: purchaser_address,
  issue_date: '05/03/2016',
  due_date: '19/03/2016',
  total: '$ 900',
  bank_account_number: '156546546465',
  description: "You can use 20% discount for the next order with the code:\nDISCOUNT",
  items: [item],
  note: "This is a note at the end.\nA note with two lines."
)

InvoicePrinter.print(
  document: invoice,
  logo: File.expand_path('../prawn.png', __FILE__),
  file_name: 'simple_invoice.pdf'
)

InvoicePrinter.print(
  document: invoice,
  logo: File.expand_path('../prawn.png', __FILE__),
  file_name: 'simple_invoice_a4.pdf',
  page_size: :a4
)
