<img src="./assets/logo.png" width="300" />

&nbsp;

**Super simple PDF invoicing.** InvoicePrinter is a server, command line program and pure Ruby library to generate PDF invoices in no time. You can use Ruby or JSON as the invoice representation to build the final PDF.

## Philosophy

- **Simple**, no styling required, no calculation, no money formatting (bring your own)
- **Pure Ruby**, no dependency on system libraries or browsers
- **Fast**, so you can render invoices on the fly during requests

## Examples

| Simple invoice |
| -------------- |
| <a href="https://github.com/strzibny/invoice_printer/raw/master/examples/promo.pdf"><img src="./examples/picture.jpg" width="180" /></a>|

See more usecases in the `examples/` directory.

## Features

### Format / Style
- Page size (A4 or US letter)
- Page numbers
- Configurable font file
- Logotype (as image scaled to fit 50px of height)
- Background (as image)
- Stamp & signature (as image)

### Information / Fields
- Configurable field labels or descriptors (e.g. "Address: ") and field values ("1000 Main Streeet ....")
- Invoice/document name and number
- Purchaser and provider boxes with addresses and identificaton numbers
- Payment method box showing banking details including SWIFT and IBAN fields
- Issue/due dates box
- Configurable items table with item description, quantity, unit, price per unit, tax and item's total amount fields
- Final subtotal/tax/total info box
- Note

### Input Methods
- CLI
- Server
- JSON format

### Other
- Well tested

## Documentation

- [Installation](./docs/INSTALLATION.md)
- [Ruby library](./docs/LIBRARY.md)
- [Server](./docs/SERVER.md)
- [Command line](./docs/COMMAND_LINE.md)

## Copyright

Copyright 2015-2019 &copy; [Josef Strzibny](http://strzibny.name/). MIT licensed.
