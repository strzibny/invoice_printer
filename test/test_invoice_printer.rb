require 'test_helper'

class InvoicePrinterTest < Minitest::Test

  def setup

  end

  def test_render_document
    invoice = InvoicePrinter::Document.new(
      InvoicePrinterHelper.default_document
    )
    rendered_pdf = InvoicePrinter.render(
      document: invoice
    )
    doc_analysis = PDF::Inspector::Text.analyze(rendered_pdf)
    assert_equal invoice.to_a, doc_analysis.strings
  end
end
