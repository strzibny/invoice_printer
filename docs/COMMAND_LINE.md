# InvoicePrinter CLI

InvoicePrinter ships with a command line executable called `invoice_printer`.

It supports all features except it only accepts JSON as an input.

```
$ invoice_printer --help
Usage: invoice_printer [options]

Options:

  -d, --document   document as JSON
    -l, --labels   labels as JSON
          --font   path to font or builtin font name
     -s, --stamp   path to stamp
          --logo   path to logotype
    --background   path to background image
     --page-size   letter or a4 (letter is the default)
  -f, --filename   output path
    -r, --render   directly render PDF stream (filename option will be ignored)
```
## Examples

```
$ invoice_printer --document '{"number":"c. 198900000001","provider_name":"Petr Novy","provider_tax_id":"56565656","provider_tax_id2":"","provider_lines":"Rolnická 1\n747 05  Opava\nKateřinky","purchaser_name":"Adam Cerny","purchaser_tax_id":"","purchaser_tax_id2":"","purchaser_lines":"Ostravská 1\n747 70  Opava","issue_date":"05/03/2016","due_date":"19/03/2016","subtotal":"Kc 10.000","tax":"Kc 2.100","tax2":"","tax3":"","total":"Kc 12.100,-","bank_account_number":"156546546465","account_iban":"IBAN464545645","account_swift":"SWIFT5456","items":[{"name":"Konzultace","quantity":"2","unit":"hod","price":"Kc 500","tax":"","tax2":"","tax3":"","amount":"Kc 1.000"},{"name":"Programovani","quantity":"10","unit":"hod","price":"Kc 900","tax":"","tax2":"","tax3":"","amount":"Kc 9.000"}],"note":"Osoba je zapsána v zivnostenském rejstríku."}' --font Overpass-Regular.ttf --filename out.pdf
```
