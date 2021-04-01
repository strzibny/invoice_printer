source 'https://rubygems.org'

# Specify server's gemspec since it will have all dependencies
gemspec name: 'invoice_printer_server'

group :test do
  gem 'pdf-inspector'
  gem 'minitest'
  gem 'rack-test', require: 'rack/test'
end

group :benchmark do
  gem 'benchmark_driver', '0.15.17'
  # For generating benchmark reports with --output gruff
  gem 'benchmark_driver-output-gruff'
end