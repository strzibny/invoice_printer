require 'test_helper'

class InvoicePrinterTest < Minitest::Test
  include InvoicePrinterHelpers

  def test_render_document
    invoice      = InvoicePrinter::Document.new(**default_document_params)
    rendered_pdf = InvoicePrinter.render(document: invoice)
    pdf_analysis = PDF::Inspector::Text.analyze(rendered_pdf)
    strings      = InvoicePrinter::PDFDocument.new(document: invoice).to_a

    assert_equal strings, pdf_analysis.strings
  end

  def test_render_document_from_json
    invoice           = InvoicePrinter::Document.new(**default_document_params)
    invoice_json      = JSON.parse(invoice.to_json)
    invoice_from_json = InvoicePrinter::Document.from_json(invoice_json)
    rendered_pdf      = InvoicePrinter.render(document: invoice_from_json)
    pdf_analysis      = PDF::Inspector::Text.analyze(rendered_pdf)
    strings           = InvoicePrinter::PDFDocument.new(document: invoice).to_a

    assert_equal strings, pdf_analysis.strings
  end
end
