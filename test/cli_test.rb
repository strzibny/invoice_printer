require 'test_helper'
require 'open3'

class CLITest < Minitest::Test
  include InvoicePrinterHelpers

  def setup
    t = Time.now.strftime("%Y%m%d")
    tmpname = "/tmp/invoice-#{t}-#{$$}-#{rand(0x100000000).to_s(36)}-fd"

    @invoice         = InvoicePrinter::Document.new(**default_document_params)
    @invoice_as_json = @invoice.to_json
    @output_path     = tmpname
  end

  def teardown
    File.unlink @output_path if File.exist?(@output_path)
  end

  def test_print_to_file
    command = "bin/invoice_printer " +
              "--document '#{@invoice_as_json}' " +
              "--labels '#{labels_hash.to_json}' " +
              "--logo '#{logo_path}' " +
              "--background '#{background_path}' " +
              "--filename #{@output_path}"

    exit_status, command_stdout, command_stderr = nil

    Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
      stdin.close
      command_stdout = stdout.read
      command_stderr = stderr.read
      exit_status    = wait_thr.value
    end

    assert_equal '', command_stderr
    assert_equal '', command_stdout
    assert_equal 0,  exit_status

    expected_pdf_path = "#{@output_path}.expected_letter"

    InvoicePrinter.print(
      document:   @invoice,
      labels:     labels_hash,
      logo:       logo_path,
      background: background_path,
      page_size:  :letter,
      file_name:  expected_pdf_path
    )

    similarity = (File.read(expected_pdf_path) == File.read(@output_path))
    assert_equal true, similarity, "#{@output_path} does not match #{expected_pdf_path}"

    File.unlink expected_pdf_path
  end

  def test_print_to_file_a4
    command = "bin/invoice_printer " +
              "--document '#{@invoice_as_json}' " +
              "--labels '#{labels_hash.to_json}' " +
              "--logo '#{logo_path}' " +
              "--background '#{background_path}' " +
              "--page-size a4 " +
              "--filename #{@output_path}"

    exit_status, command_stdout, command_stderr = nil

    Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
      stdin.close
      command_stdout = stdout.read
      command_stderr = stderr.read
      exit_status    = wait_thr.value
    end

    assert_equal '', command_stderr
    assert_equal '', command_stdout
    assert_equal 0,  exit_status

    expected_pdf_path = "#{@output_path}.expected_a4"

    InvoicePrinter.print(
      document:   @invoice,
      labels:     labels_hash,
      logo:       logo_path,
      background: background_path,
      page_size:  :a4,
      file_name:  expected_pdf_path
    )

    similarity = (File.read(expected_pdf_path) == File.read(@output_path))
    assert_equal true, similarity, "#{@output_path} does not match #{expected_pdf_path}"

    File.unlink expected_pdf_path
  end

  private

  def labels_hash
    sublabels = { sublabels: { name: 'Sublabel name' } }

    { provider: 'Default Provider',
      purchaser: 'Default Purchaser' }.merge!(sublabels)
  end

  def logo_path
    File.expand_path('../../examples/logo.png', __FILE__)
  end

  def background_path
    File.expand_path('../../examples/background.png', __FILE__)
  end
end