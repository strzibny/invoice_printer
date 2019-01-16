# InvoicePrinter CLI

InvoicePrinter ships with a command line executable called `invoice_printer`.

It supports all features except it only accepts JSON as an input.

```
$ invoice_printer --help
Usage: invoice_printer [options]

Options:

  -d, --document   document as JSON
    -l, --labels   labels as JSON
          --font   path to font
     -s, --stamp   path to stamp
          --logo   path to logotype
    --background   path to background image
     --page-size   letter or a4 (letter is the default)
  -f, --filename   output path
    -r, --render   directly render PDF stream (filename option will be ignored)

```
