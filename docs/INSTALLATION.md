# Installation

## Via RubyGems

This requires Ruby to be installed.

Install the library and command line as:

    $ gem install invoice_printer

Or the server version as:

    $ gem install invoice_printer_server

To have builtin fonts available install:

    $ gem install invoice_printer_fonts

### With Bundler

Add this line to your application's Gemfile:

```ruby
gem 'invoice_printer'
```

For the server:

```ruby
gem 'invoice_printer_server'
```

To have builtin fonts available add:

```ruby
gem 'invoice_printer_fonts'
```

And then execute:

    $ bundle

## Using Docker

InvoicePrinter Server is available as a Docker image.

This requires Docker to be installed and running.

To get it:

```bash
$ sudo docker pull strzibnyj/invoice_printer_server
```