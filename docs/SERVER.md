# InvoicePrinter Server

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
{ "result": "ok", "data": "base64 encoded PDF document" }
```

On error a `400` response is returned:

```json
{ "result": "error", "error": "error description" }
```

#### Examples

### curl

Example of calling the API to render a document using `curl`:

```
$ curl -X POST http://0.0.0.0:9393/render -H "Content-Type: application/json" --data '{"document":{"number":"c. 198900000001","provider_name":"Petr Novy","provider_tax_id":"56565656","provider_tax_id2":"","provider_street":"Rolnicka","provider_street_number":"1","provider_postcode":"747 05","provider_city":"Opava","provider_city_part":"Katerinky","provider_extra_address_line":"","purchaser_name":"Adam Cerny","purchaser_tax_id":"","purchaser_tax_id2":"","purchaser_street":"Ostravska","purchaser_street_number":"1","purchaser_postcode":"747 70","purchaser_city":"Opava","purchaser_city_part":"","purchaser_extra_address_line":"","issue_date":"05/03/2016","due_date":"19/03/2016","subtotal":"Kc 10.000","tax":"Kc 2.100","tax2":"","tax3":"","total":"Kc 12.100,-","bank_account_number":"156546546465","account_iban":"IBAN464545645","account_swift":"SWIFT5456","items":[{"name":"Konzultace","quantity":"2","unit":"hod","price":"Kc 500","tax":"","tax2":"","tax3":"","amount":"Kc 1.000"},{"name":"Programovani","quantity":"10","unit":"hod","price":"Kc 900","tax":"","tax2":"","tax3":"","amount":"Kc 9.000"}],"note":"Osoba je zapsána v zivnostenském rejstríku."}}'
```

### Node.js

See [/examples/clients/node.js](/examples/clients/node.js).

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
{ "result": "ok", "path": "/path/basically/what/was/sent/as/filepath" }
```

On error a `400` response is returned:

```json
{ "result": "error", "error": "error description" }
```
