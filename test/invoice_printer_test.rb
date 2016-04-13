require 'test_helper'

class InvoicePrinterTest < Minitest::Test
  include InvoicePrinterHelpers

  def test_render_document
    invoice = InvoicePrinter::Document.new(default_document_params)
    rendered_pdf = InvoicePrinter.render(document: invoice)
    pdf_analysis = PDF::Inspector::Text.analyze(rendered_pdf)
    strings = InvoicePrinter::PDFDocument.new(document: invoice).to_a

    assert_equal strings, pdf_analysis.strings
  end
end
