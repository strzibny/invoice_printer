require 'bundler'
Bundler::GemHelper.install_tasks(name: 'invoice_printer_server')

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
require 'invoice_printer'

require 'rake/testtask'
Rake::TestTask.new('test') do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*test.rb'
  t.verbose = true
end
