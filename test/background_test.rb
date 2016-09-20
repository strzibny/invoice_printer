require 'test_helper'

class BackgroundTest < Minitest::Test
  include InvoicePrinterHelpers

  def setup
    @invoice = InvoicePrinter::Document.new(default_document_params)
  end

  def test_background_render
    assert_silent do
      InvoicePrinter.render(document: @invoice, background: './examples/background.jpg')
      InvoicePrinter.render(document: @invoice, background: nil)
      InvoicePrinter.render(document: @invoice)
    end
  end

  def test_missing_background_raises_an_exception
    assert_raises(ArgumentError) do
      InvoicePrinter.render(document: @invoice, background: 'missing.jpg')
    end
  end
end
