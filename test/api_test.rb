require 'test_helper'
require 'invoice_printer/server'

class ApiTest < Minitest::Test
  include Rack::Test::Methods
  include InvoicePrinterHelpers

  def app
    InvoicePrinter::Server.freeze.app
  end

  def setup
    @test_dir = File.absolute_path('./tmp/invoice_printer_api')
    FileUtils.mkdir_p @test_dir
  end

  def teardown
    FileUtils.rm_rf @test_dir if File.exist?(@test_dir)
  end

  # Test POST /print

  def test_print_with_invalid_json
    header 'Content-Type', 'application/json'
    post '/print', nil

    body = JSON.parse last_response.body

    assert !last_response.ok?
    assert_equal body, { 'result' => 'error', 'error' => 'Invalid JSON.' }
  end

  def test_print_with_valid_document
    invoice = InvoicePrinter::Document.new(**default_document_params)

    json = {
      'document' => invoice.to_h,
      'filename' => "#{@test_dir}/test"
    }.to_json

    header 'Content-Type', 'application/json'
    post '/print', json

    body = JSON.parse last_response.body

    assert last_response.ok?
    assert_equal body, { 'result' => 'ok', 'path' => "#{@test_dir}/test" }
  end

  # Test POST /render

  def test_render_with_invalid_json
    header 'Content-Type', 'application/json'
    post '/render', nil

    body = JSON.parse last_response.body

    assert !last_response.ok?
    assert_equal body, { 'result' => 'error', 'error' => 'Invalid JSON.' }
  end

  def test_render_with_valid_document
    invoice  = InvoicePrinter::Document.new(**default_document_params)
    output   = InvoicePrinter.render(document: invoice)

    json = {
      'document' => invoice.to_h
    }.to_json

    header 'Content-Type', 'application/json'
    post '/render', json

    body = JSON.parse last_response.body

    assert last_response.ok?
    assert_equal body, { 'result' => 'ok', 'data' => Base64.strict_encode64(output) }
  end
end