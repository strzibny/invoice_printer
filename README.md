# InvoicePrinter

Super simple PDF invoicing in pure Ruby (based on Prawn library).

InvoicePrinter does not impose any validations nor calculations on you. It is
designed only to provide an interface to build the PDF version of these documents.

**This project is still in development. 0.0.x versions are all development versions.**

<a href="https://github.com/strzibny/invoice_printer/raw/master/examples/complex_invoice.pdf">
<img src="./examples/complex_invoice.png" width="368" />
</a>

See more usecases in the `examples/` directory.

## Features

- Invoice/document name and number
- Purchaser and provider boxes with addresses and identificaton numbers
- Payment method box showing banking details including SWIFT and IBAN fields
- Issue/due dates box
- Configurable items' table with item description, quantity, unit, price per unit, tax and item's total amount fields
- Final subtotal/tax/total info box
- Page numbers
- Configurable labels
- Configurable font file
- Logotype (as image scaled to fit 50px of height)
- Stamp & signature (as image)
- Note
- Well tested

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'invoice_printer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install invoice_printer

## Usage

The simplest way how to create your invoice PDF is to create an invoice object
and pass it to printer:

```ruby
item = InvoicePrinter::Document::Item.new(
  ...
)

invoice = InvoicePrinter::Document.new(
  ...
  items: [item, ...]
)

InvoicePrinter.print(
  document: invoice,
  file_name: 'invoice.pdf'
)
```

Here is an full example for creating the document object:

```ruby
item = InvoicePrinter::Document::Item.new(
  name: 'Web consultation',
  quantity: nil,
  unit: 'hours',
  price: '$ 25',
  tax: '$ 1',
  amount: '$ 100'
)

invoice = InvoicePrinter::Document.new(
  number: '201604030001',
  provider_name: 'Business s.r.o.',
  provider_tax_id: '56565656',
  provider_tax_id2: '465454',
  provider_street: 'Rolnicka',
  provider_street_number: '1',
  provider_postcode: '747 05',
  provider_city: 'Opava',
  provider_city_part: 'Katerinky',
  provider_extra_address_line: 'Czech Republic',
  purchaser_name: 'Adam',
  purchaser_tax_id: '',
  purchaser_tax_id2: '',
  purchaser_street: 'Ostravska',
  purchaser_street_number: '1',
  purchaser_postcode: '747 70',
  purchaser_city: 'Opava',
  purchaser_city_part: '',
  purchaser_extra_address_line: '',
  issue_date: '19/03/3939',
  due_date: '19/03/3939',
  subtotal: '175',
  tax: '5',
  tax2: '10',
  tax3: '20',
  total: '$ 200',
  bank_account_number: '156546546465',
  account_iban: 'IBAN464545645',
  account_swift: 'SWIFT5456',
  items: [item],
  note: 'A note...'
)
```

### Localization

To localize your documents you can set both global defaults or instance
overrides:

```ruby
InvoicePrinter.labels = {
  provider: 'Dodavatel'
}

labels = {
  purchaser: 'Customer'
}

InvoicePrinter.print(
  document: invoice,
  labels: labels,
  file_name: 'invoice.pdf'
)
```

Here is the full list of labels to configure. You can paste and edit this block
to `initializers/invoice_printer.rb` if you are using Rails.

```ruby
InvoicePrinter.labels = {
  name: 'Invoice'
  provider: 'Provider',
  purchaser: 'Purchaser',
  tax_id: 'Identification number',
  tax_id2: 'Identification number',
  payment: 'Payment',
  payment_by_transfer: 'Payment by bank transfer on the account below:',
  payment_in_cash: 'Payment in cash',
  account_number: 'Account NO',
  swift: 'SWIFT',
  iban: 'IBAN',
  issue_date: 'Issue date',
  due_date: 'Due date',
  item: 'Item',
  quantity: 'Quantity',
  unit: 'Unit',
  price_per_item: 'Price per item',
  amount: 'Amount',
  tax: 'Tax',
  tax2: 'Tax 2',
  tax3: 'Tax 3',
  subtotal: 'Subtotal'
  total: 'Total'
}
```

To support specific characters you might need to specify a TTF font to be used:

```
InvoicePrinter.print(
  ...
  font: File.expand_path('../Overpass-Regular.ttf', __FILE__)
)
```

We recommend you DejaVuSans and Overpass fonts.

## Copyright

Copyright 2015-2016 &copy; [Josef Strzibny](http://strzibny.name/). MIT licensed.

Originally extracted from and created for an open source single-entry invoicing app [InvoiceBar](https://github.com/strzibny/invoicebar).
