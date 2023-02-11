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
     --bold-font   path to bold font or builtin font name
     -s, --stamp   path to stamp
          --logo   path to logotype
    --background   path to background image
     --page-size   letter or a4 (letter is the default)
  -f, --filename   output path
    -r, --render   directly render PDF stream (filename option will be ignored)
```

## Document

JSON document with all possible fields filled:

```json
{
  "number":"c. 198900000001",
  "provider_name":"Petr Novy",
  "provider_tax_id":"56565656",
  "provider_tax_id2":"",
  "provider_lines":"Rolnická 1\n747 05  Opava\nKateřinky",
  "purchaser_name":"Adam Cerny",
  "purchaser_tax_id":"",
  "purchaser_tax_id2":"",
  "purchaser_lines":"Ostravská 1\n747 70  Opava",
  "issue_date":"05/03/2016",
  "due_date":"19/03/2016",
  "variable_symbol":"198900000001",
  "subtotal":"Kc 10.000",
  "tax":"Kc 2.100",
  "tax2":"",
  "tax3":"",
  "variable":"Extra column",
  "total":"Kc 12.100,-",
  "bank_account_number":"156546546465",
  "account_iban":"IBAN464545645",
  "account_swift":"SWIFT5456",
  "description": "We are invoicing the following items:",
  "items":[
    {
       "name":"Konzultace",
       "variable": "",
       "quantity":"2",
       "unit":"hod",
       "price":"Kc 500",
       "tax":"",
       "tax2":"",
       "tax3":"",
       "amount":"Kc 1.000"
    },
    {
       "name":"Programovani",
       "variable": "",
       "quantity":"10",
       "unit":"hod",
       "price":"Kc 900",
       "tax":"",
       "tax2":"",
       "tax3":"",
       "amount":"Kc 9.000"
    }
  ],
  "note":"Osoba je zapsána v zivnostenském rejstríku."
}
```

**Note**: `provider_lines` and `purchaser_lines` are 4 lines of data separated by new line character`\n`. Other lines are being stripped.

**Note**: There is `variable` field that can be used for any
extra column.

## Field labels

All labels:

```json
{
  "name":"Invoice",
  "provider":"Provider",
  "purchaser":"Purchaser",
  "tax_id":"Identification number",
  "tax_id2":"Identification number",
  "payment":"Payment",
  "payment_by_transfer":"Payment by bank transfer on the account below:",
  "payment_in_cash":"Payment in cash",
  "account_number":"Account NO",
  "swift":"SWIFT",
  "iban":"IBAN",
  "issue_date":"Issue date",
  "due_date": "Due date",
  "variable_symbol": "Variable symbol",
  "item":"Item",
  "variable":"",
  "quantity":"Quantity",
  "unit": "Unit",
  "price_per_item":"Price per item",
  "amount":"Amount",
  "tax":"Tax",
  "tax2":"Tax 2",
  "tax3":"Tax 3",
  "subtotal":"Subtotal",
  "total":"Total",
  "sublabels":{
    "name":"Faktura",
    "provider":"Prodejce",
    "purchaser":"Kupující",
    "tax_id":"IČ",
    "tax_id2":"DIČ",
    "payment":"Forma úhrady",
    "payment_by_transfer":"Platba na následující účet:",
    "account_number":"Číslo účtu",
    "issue_date":"Datum vydání",
    "due_date":"Datum splatnosti",
    "item":"Položka",
    "variable:":"",
    "quantity":"Počet",
    "unit":"MJ",
    "price_per_item":"Cena za položku",
    "amount":"Celkem bez daně",
    "subtota":"Cena bez daně",
    "tax":"DPH 21 %",
    "total":"Celkem"
  }
}
```
**Note**: Notice the `sublabels` which you might not want to necessary include.

## Built-in fonts

Supported builtin fonts are: `overpass`, `opensans`, and `roboto`. They ship with bold versions.

## Examples

```
$ invoice_printer --document '{"number":"c. 198900000001","provider_name":"Petr Novy","provider_tax_id":"56565656","provider_tax_id2":"","provider_lines":"Rolnická 1\n747 05  Opava\nKateřinky","purchaser_name":"Adam Cerny","purchaser_tax_id":"","purchaser_tax_id2":"","purchaser_lines":"Ostravská 1\n747 70  Opava","issue_date":"05/03/2016","due_date":"19/03/2016","subtotal":"Kc 10.000","tax":"Kc 2.100","tax2":"","tax3":"","total":"Kc 12.100,-","bank_account_number":"156546546465","account_iban":"IBAN464545645","account_swift":"SWIFT5456","items":[{"name":"Konzultace","quantity":"2","unit":"hod","price":"Kc 500","tax":"","tax2":"","tax3":"","amount":"Kc 1.000"},{"name":"Programovani","quantity":"10","unit":"hod","price":"Kc 900","tax":"","tax2":"","tax3":"","amount":"Kc 9.000"}],"note":"Osoba je zapsána v zivnostenském rejstríku."}' --font Overpass-Regular.ttf --filename out.pdf
```
