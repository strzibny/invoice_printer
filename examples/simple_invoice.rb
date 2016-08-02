#!/usr/bin/env ruby
# This is an example of a very simple invoice.

lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'invoice_printer'

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
  provider_street: '5th Avenue',
  provider_street_number: '1',
  provider_postcode: '747 05',
  provider_city: 'NYC',
  purchaser_name: 'Will Black',
  purchaser_street: '7th Avenue',
  purchaser_street_number: '1',
  purchaser_postcode: '747 70',
  purchaser_city: 'NYC',
  issue_date: '05/03/2016',
  due_date: '19/03/2016',
  total: '$ 900',
  bank_account_number: '156546546465',
  items: [item],
  note: 'This is a note at the end.'
)

InvoicePrinter.print(
  document: invoice,
  file_name: 'simple_invoice.pdf'
)
