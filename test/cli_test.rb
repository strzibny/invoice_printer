require 'test_helper'
require 'open3'

class CLITest < Minitest::Test
  include InvoicePrinterHelpers

  def setup
    @invoice         = InvoicePrinter::Document.new(default_document_params)
    @invoice_as_json = @invoice.to_json
    @output_path     = Dir::Tmpname.make_tmpname('/tmp/invoice', nil)
  end

  def teardown
    File.unlink @output_path if File.exist?(@output_path)
  end

  def test_print_to_file
    command = "bin/invoice_printer --filename #{@output_path} --document '#{@invoice_as_json}'"

    exit_status, command_stdout, command_stderr = nil

    Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
      stdin.close
      command_stdout = stdout.read
      command_stderr = stderr.read
      exit_status    = wait_thr.value
    end

    assert_equal 0,  exit_status
    assert_equal '', command_stdout
    assert_equal '', command_stderr

    rendered_pdf = File.read(@output_path)
    pdf_analysis = PDF::Inspector::Text.analyze(rendered_pdf)

    assert_equal 48, pdf_analysis.strings.size
  end
end