require 'bundler/gem_tasks'
require 'rake/testtask'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
require 'invoice_printer'

Rake::TestTask.new('test') do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*test.rb'
  t.verbose = true
end
