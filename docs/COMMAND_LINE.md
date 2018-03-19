# InvoicePrinter CLI

InvoicePrinter ships with a command line executable called `invoice_printer`.

It supports all features except it only accepts JSON as an input.

```
$ invoice_printer --help
Usage: invoice_printer [options]

Options:

    -l, --labels   labels as JSON
  -d, --document   document as JSON
     -s, --stamp   path to stamp
          --logo   path to logotype
          --font   path to font
     --page_size   letter or a4 (letter is the default)
  -f, --filename   output path
    -r, --render   directly render PDF stream (filename option will be ignored)
```
