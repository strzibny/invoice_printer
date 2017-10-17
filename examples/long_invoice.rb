#!/usr/bin/env ruby
# This is an example of a very simple invoice.

lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'invoice_printer'

labels = {
  tax: '10% VAT'
}

item = InvoicePrinter::Document::Item.new(
  name: 'Programming',
  quantity: '10',
  unit: 'hr',
  price: '$ 60',
  tax: '$ 60',
  amount: '$ 600'
)

item2 = InvoicePrinter::Document::Item.new(
  name: 'Consulting',
  quantity: '10',
  unit: 'hr',
  price: '$ 30',
  tax: '$ 30',
  amount: '$ 300'
)

item3 = InvoicePrinter::Document::Item.new(
  name: 'Support',
  quantity: '20',
  unit: 'hr',
  price: '$ 15',
  tax: '$ 30',
  amount: '$ 330'
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
  subtotal: '$ 1,000',
  tax: '$ 100',
  total: '$ 1,100',
  bank_account_number: '156546546465',
  items: [item, item2, item3] * 20,
  note: 'This is a note at the end.'
)

InvoicePrinter.print(
  document: invoice,
  labels: labels,
  stamp: 'stamp.png',
  logo: 'prawn.png',
  file_name: 'long_invoice.pdf'
)

InvoicePrinter.print(
  document: invoice,
  labels: labels,
  stamp: 'stamp.png',
  logo: 'prawn.png',
  file_name: 'long_invoice_a4.pdf',
  page_size: :a4
)
