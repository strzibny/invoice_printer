require 'test_helper'

class InvoicePrinterTest < Minitest::Test
  include InvoicePrinterHelpers

  def test_render_document
    invoice = InvoicePrinter::Document.new(default_document)
    rendered_pdf = InvoicePrinter.render(document: invoice)
    doc_analysis = PDF::Inspector::Text.analyze(rendered_pdf)

    strings = InvoicePrinter::PDFDocument.new(document: invoice).to_a
    assert_equal strings, doc_analysis.strings
  end

  def test_setting_global_labels
    labels = { provider: 'Default Provider', purchaser: 'Default Purchaser' }
    InvoicePrinter.labels = labels

    invoice = InvoicePrinter::Document.new(default_document)
    rendered_pdf = InvoicePrinter.render(document: invoice)
    doc_analysis = PDF::Inspector::Text.analyze(rendered_pdf)

    assert_equal true, doc_analysis.strings.include?('Default Provider')
    assert_equal true, doc_analysis.strings.include?('Default Purchaser')
  end

  def test_setting_instant_labels
    labels = { provider: 'Current Provider', purchaser: 'Current Purchaser' }

    invoice = InvoicePrinter::Document.new(default_document)
    rendered_pdf = InvoicePrinter.render(document: invoice, labels: labels)
    doc_analysis = PDF::Inspector::Text.analyze(rendered_pdf)

    assert_equal true, doc_analysis.strings.include?('Current Provider')
    assert_equal true, doc_analysis.strings.include?('Current Purchaser')
  end
end
