lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'invoice_printer/version'

ONLY_SERVER_FILES = [
  'bin/invoice_printer_server',
  'lib/invoice_printer/server.rb'
]

ONLY_FONTS_FILES = [
  'FONTS_LICENSE.txt',
  'assets/fonts/overpass/OFL-1.1.txt',
  'assets/fonts/overpass/Overpass-Regular.ttf',
  'assets/fonts/opensans/Apache-2.0.txt',
  'assets/fonts/opensans/OpenSans-Regular.ttf',
  'assets/fonts/roboto/Apache-2.0.txt',
  'assets/fonts/roboto/Roboto-Regular.ttf',
  'lib/invoice_printer/fonts.rb'
]

Gem::Specification.new do |spec|
  spec.name          = 'invoice_printer'
  spec.version       = InvoicePrinter::VERSION
  spec.authors       = ['Josef Strzibny']
  spec.email         = ['strzibny@strzibny.name']
  spec.summary       = 'Super simple PDF invoicing in pure Ruby'
  spec.description   = 'Super simple and fast PDF invoicing in pure Ruby (based on Prawn library).'
  spec.homepage      = 'https://github.com/strzibny/invoice_printer'
  spec.license       = 'MIT'

  # Remove server files
  # Remove .pdf files as they take a lot of space
  package_files = `git ls-files -z`.split("\x0")
                    .reject{ |file| ONLY_SERVER_FILES.include?(file) }
                    .reject{ |file| ONLY_FONTS_FILES.include?(file) }
                    .reject{ |file| file.match /.*\.png/ }
                    .reject{ |file| file.match /.*\.pdf/ }

  spec.files         = package_files
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.bindir        = 'bin'

  spec.required_ruby_version = '>= 2.4'

  spec.add_dependency 'json', '~> 2.1'
  spec.add_dependency 'prawn', '~> 2.4'
  spec.add_dependency 'prawn-table', '~> 0.2.2'
  spec.add_dependency 'matrix'
  spec.add_dependency 'e2mmap'

  spec.add_development_dependency 'bundler', '>= 1.7'
  spec.add_development_dependency 'rake', '>= 10.0'
end
