require 'test_helper'

class InputsTest < Minitest::Test
  include InvoicePrinterHelpers

  def test_refuse_documents_of_wrong_class
    assert_raises(StandardError) do
      InvoicePrinter::PDFDocument.new(document: String.new)
    end

    assert_raises(StandardError) do
      InvoicePrinter.render(document: String.new)
    end
  end

  def test_refuse_items_of_wrong_class
    assert_raises(StandardError) do
      InvoicePrinter::Document.new(items: String.new)
    end
  end

  def test_non_string_inputs_are_converted_to_strings
    params = default_document_params.merge(
      provider_tax_id: 12345678910,
      provider_tax_id2: 12345678910,
      purchaser_tax_id: 12345678910,
      purchaser_tax_id2: 12345678910
    )

    # No exceptions should be raised
    invoice = InvoicePrinter::Document.new(**params)
    InvoicePrinter.render(document: invoice)
  end

  def test_missing_font_raises_an_exception
    invoice = InvoicePrinter::Document.new(**default_document_params)

    assert_raises(InvoicePrinter::PDFDocument::FontFileNotFound) do
      InvoicePrinter.render(document: invoice, font: 'missing.font')
    end
  end

  def test_missing_logo_raises_an_exception
    invoice = InvoicePrinter::Document.new(**default_document_params)

    assert_raises(InvoicePrinter::PDFDocument::LogoFileNotFound) do
      InvoicePrinter.render(document: invoice, logo: 'missing.png')
    end
  end

  def test_missing_stamp_raises_an_exception
    invoice = InvoicePrinter::Document.new(**default_document_params)

    assert_raises(InvoicePrinter::PDFDocument::StampFileNotFound) do
      InvoicePrinter.render(document: invoice, stamp: 'missing.png')
    end
  end
end
