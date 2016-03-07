require 'test_helper'

class InvoicePrinterTest < Minitest::Test
  include InvoicePrinterHelpers

  def setup

  end

  def test_render_document
    invoice = InvoicePrinter::Document.new(
      default_document
    )
    rendered_pdf = InvoicePrinter.render(
      document: invoice
    )
    doc_analysis = PDF::Inspector::Text.analyze(rendered_pdf)

    strings = InvoicePrinter::PDFDocument.new(document: invoice).to_a
    assert_equal strings, doc_analysis.strings
  end
end
