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

