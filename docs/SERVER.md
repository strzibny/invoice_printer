# InvoicePrinter as a server

InvoicePrinter contains a built in server that can be run from a command line with `invoice_printer_server`.

Apart from this you can also manually mount the server inside of your Rack application.

## Running the server

### From command line

Once installed, InvoicePrinter provides `invoice_printer_server` executable that starts the Puma server:

```bash
invoice_printer_server -h 0.0.0.0 -p 5000
```


`-h` defines a host and `-p` defines a port. For help you can run `--help`.

By default server binds to `0.0.0.0:9393`.

### As mountable Rack app

If you want you can always run the server from your custom program or mount it directly from a Rack app.

`InvoicePrinter::Server` is a Rack app as any other. Example:

```ruby
require 'rack/handler/puma'
require 'invoice_printer/server'

Rack::Handler::Puma.run InvoicePrinter::Server.freeze.app
```

## Available API

Endpoints accept similar arguments as the corresponding methods to `InvoicePrinter`. `render` is used for directly getting the PDF output whereas `print` would accept `filename` option and save the document to that
file.

A content type is always `application/json` both for requests and responses.

### `POST /render`

Directly render PDF data.

Options:

- `document` - JSON representation of the document
- `labels` - JSON for labels
- `stamp` - path to stamp file
- `logo` - path to logotype file
- `font` - path to font file

On success a `200` response is returned:

```json
{ 'result': 'ok', 'data': 'base64 encoded PDF document' }
```

On error a `400` response is returned:

```json
{ 'result': 'error', 'error': 'error description' }
```

#### Example

Example of calling the API to render a document using `curl`:

```
$ curl -H "Content-Type: text/html; charset=UTF-8" --data 'document={"number":"č. 198900000001","provider_name":"Petr Nový","provider_tax_id":"56565656","provider_tax_id2":"","provider_street":"Rolnická","provider_street_number":"1","provider_postcode":"747 05","provider_city":"Opava","provider_city_part":"Kateřinky","provider_extra_address_line":"","purchaser_name":"Adam Černý","purchaser_tax_id":"","purchaser_tax_id2":"","purchaser_street":"Ostravská","purchaser_street_number":"1","purchaser_postcode":"747 70","purchaser_city":"Opava","purchaser_city_part":"","purchaser_extra_address_line":"","issue_date":"05/03/2016","due_date":"19/03/2016","subtotal":"Kč 10.000","tax":"Kč 2.100","tax2":"","tax3":"","total":"Kč 12.100,-","bank_account_number":"156546546465","account_iban":"IBAN464545645","account_swift":"SWIFT5456","items":[{"name":"Konzultace","quantity":"2","unit":"hod","price":"Kč 500","tax":"","tax2":"","tax3":"","amount":"Kč 1.000"},{"name":"Programování","quantity":"10","unit":"hod","price":"Kč 900","tax":"","tax2":"","tax3":"","amount":"Kč 9.000"}],"note":"Osoba je zapsána v živnostenském rejstříku."}' -X POST http://0.0.0.0:9393/render
```

### `POST /print`

Print resulting document to a file.

Options:

- `document` - JSON representation of the document
- `labels` - JSON for labels
- `stamp` - path to stamp file
- `logo` - path to logotype file
- `font` - path to font file
- `filename` - path for saving the generated output PDF

On success a `200` response is returned:

```json
{ 'result': 'ok', 'path': 'path, basically what was sent as filepath' }
```

On error a `400` response is returned:

```json
{ 'result': 'error', 'error': 'error description' }
```
