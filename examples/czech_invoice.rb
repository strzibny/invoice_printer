#!/usr/bin/env ruby
# This is an example of a Czech invoice.
#
# Due to the special characters it requires Overpass-Regular.ttf font to be
# present in this directory.

lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'invoice_printer'

labels = {
  name: 'Faktura',
  provider: 'Prodejce',
  purchaser: 'Kupující',
  ic: 'IČ',
  dic: 'DIČ',
  payment: 'Forma úhrady',
  payment_by_transfer: 'Platba na následující účet:',
  account_number: 'Číslo účtu:',
  issue_date: 'Datum vydání:',
  due_date: 'Datum splatnosti:',
  item: 'Položka',
  quantity: 'Počet',
  unit: 'MJ',
  price_per_item: 'Cena za položku',
  subtotal: 'Cena bez daně',
  tax: 'DPH 21 %',
  amount: 'Celkem bez daně',
  total: 'Celkem'
}

first_item = InvoicePrinter::Document::Item.new(
  name: 'Konzultace',
  quantity: '2',
  unit: 'hod',
  price: 'Kč 500',
  amount: 'Kč 1.000'
)

second_item = InvoicePrinter::Document::Item.new(
  name: 'Programování',
  quantity: '10',
  unit: 'hod',
  price: 'Kč 900',
  amount: 'Kč 9.000'
)

invoice = InvoicePrinter::Document.new(
  number: 'č. 198900000001',
  provider_name: 'Petr Nový',
  provider_ic: '56565656',
  provider_street: 'Rolnická',
  provider_street_number: '1',
  provider_postcode: '747 05',
  provider_city: 'Opava',
  provider_city_part: 'Kateřinky',
  purchaser_name: 'Adam Černý',
  purchaser_street: 'Ostravská',
  purchaser_street_number: '1',
  purchaser_postcode: '747 70',
  purchaser_city: 'Opava',
  issue_date: '05/03/2016',
  due_date: '19/03/2016',
  subtotal: 'Kč 10.000',
  tax: 'Kč 2.100',
  total: 'Kč 12.100,-',
  bank_account_number: '156546546465',
  account_iban: 'IBAN464545645',
  account_swift: 'SWIFT5456',
  items: [first_item, second_item]
)

InvoicePrinter.print(
  document: invoice,
  labels: labels,
  font: File.expand_path('../Overpass-Regular.ttf', __FILE__),
  file_name: 'czech_invoice.pdf'
)
