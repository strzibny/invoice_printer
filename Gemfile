source 'https://rubygems.org'

# Specify your gem's dependencies in invoice_printer.gemspec
gemspec

group :test do
  gem 'pdf-inspector'
  gem 'minitest'
  gem 'rack-test', require: 'rack/test'
end

group :benchmark do
  gem 'benchmark_driver', '0.14.11'
  # For generating benchmark reports with --output gruff
  gem 'benchmark_driver-output-gruff'
end