require 'test_helper'

class BackgroundTest < Minitest::Test
  include InvoicePrinterHelpers

  def setup
    @invoice = InvoicePrinter::Document.new(**default_document_params)
  end

  def test_background_render
    InvoicePrinter.render(document: @invoice, background: './examples/background.png')
    InvoicePrinter.render(document: @invoice, background: nil)
    InvoicePrinter.render(document: @invoice)
  end

  def test_missing_background_raises_an_exception
    assert_raises(ArgumentError) do
      InvoicePrinter.render(document: @invoice, background: 'missing.jpg')
    end
  end
end
