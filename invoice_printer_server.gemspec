lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'invoice_printer/version'

SERVER_FILES = [
  'LICENSE.txt',
  'bin/invoice_printer_server',
  'lib/invoice_printer/server.rb',
  'lib/invoice_printer/version.rb'
]

Gem::Specification.new do |spec|
  spec.name          = 'invoice_printer_server'
  spec.version       = InvoicePrinter::VERSION
  spec.authors       = ['Josef Strzibny']
  spec.email         = ['strzibny@strzibny.name']
  spec.summary       = 'Super simple PDF invoicing in pure Ruby'
  spec.description   = 'Super simple and fast PDF invoicing in pure Ruby (based on Prawn library).'
  spec.homepage      = 'https://github.com/strzibny/invoice_printer'
  spec.license       = 'MIT'

  # Include only server files
  spec.files         = SERVER_FILES
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.bindir        = 'bin'

  spec.required_ruby_version = '>= 2.4'

  spec.add_dependency 'invoice_printer', InvoicePrinter::VERSION
  spec.add_dependency 'json', '~> 2.1'
  spec.add_dependency 'roda', '~> 3.5'
  spec.add_dependency 'puma', '>= 3.9.0'

  spec.add_development_dependency 'bundler', '>= 1.7'
  spec.add_development_dependency 'rake', '>= 10.0'
end
