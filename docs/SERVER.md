# InvoicePrinter Server

InvoicePrinter comes with a server that can be run from a command line with `invoice_printer_server`. Since 2.x releases this server is packaged separately in `invoice_printer_server` gem.

Apart from this you can also manually mount the server inside of your Rack application.

## Running the server

### From a command line

Once installed, InvoicePrinter Server provides `invoice_printer_server` executable that starts the Puma server:

```bash
$ invoice_printer_server -h 0.0.0.0 -p 5000
```

`-h` defines a host and `-p` defines a port. For help you can run `--help`.

By default server binds to `0.0.0.0:9393`.

#### As a Docker image

Get the public image and run it:

```bash
$ sudo docker pull strzibnyj/invoice_printer_server:$VERSION
$ sudo docker run -d -p 9393:9393 -v ~/path/to/invocies:/data:Z -t docker.io/strzibnyj/invoice_printer_server
```
You can use `latest` as a `$VERSION`. Specifying the `-v` option is only required when using the `/print` action to create the documents at certain path. It will allow you to provide the desired filename as "/data/invoice-name.pdf".

The server will then be available on `0.0.0.0:9393`.

Docker image already contains the optional `invoice_printer_fonts` gem.

### As a mountable Rack app

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
- `font` - path to font file or builtin font name
- `bold_font` - path to bold font file or builtin font name
- `stamp` - path to stamp file
- `logo` - path to logotype file
- `background` - path to background file
- `page_size` - letter or A4 page size

These parameters are the same as for the [command line](./COMMAND_LINE.md).

On success a `200` response is returned:

```json
{ "result": "ok", "data": "base64 encoded PDF document" }
```

On error a `400` response is returned:

```json
{ "result": "error", "error": "error description" }
```

#### Examples

##### curl

Example of calling the API to render a document using `curl`:

```
$ curl -X POST http://0.0.0.0:9393/render -H "Content-Type: application/json" --data '{"document":{"number":"c. 198900000001","provider_name":"Petr Novy","provider_tax_id":"56565656","provider_tax_id2":"","provider_lines":"Rolnická 1\n747 05  Opava\nKateřinky","purchaser_name":"Adam Cerny","purchaser_tax_id":"","purchaser_tax_id2":"","purchaser_lines":"Ostravská 1\n747 70  Opava","issue_date":"05/03/2016","due_date":"19/03/2016","subtotal":"Kc 10.000","tax":"Kc 2.100","tax2":"","tax3":"","total":"Kc 12.100,-","bank_account_number":"156546546465","account_iban":"IBAN464545645","account_swift":"SWIFT5456","items":[{"name":"Konzultace","quantity":"2","unit":"hod","price":"Kc 500","tax":"","tax2":"","tax3":"","amount":"Kc 1.000"},{"name":"Programovani","quantity":"10","unit":"hod","price":"Kc 900","tax":"","tax2":"","tax3":"","amount":"Kc 9.000"}],"note":"Osoba je zapsána v zivnostenském rejstríku."}}'
```

##### Node.js

See [/examples/clients/node.js](/examples/clients/node.js).

### `POST /print`

Print resulting document to a file.

Options:

- `document` - JSON representation of the document
- `labels` - JSON for labels
- `font` - path to font file or builtin font name
- `bold_font` - path to bold font file or builtin font name
- `stamp` - path to stamp file
- `logo` - path to logotype file
- `background` - path to background file
- `page_size` - letter or A4 page size
- `filename` - path for saving the generated output PDF

On success a `200` response is returned:

```json
{ "result": "ok", "path": "/path/basically/what/was/sent/as/filepath" }
```

On error a `400` response is returned:

```json
{ "result": "error", "error": "error description" }
```
