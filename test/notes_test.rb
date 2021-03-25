require 'test_helper'

class NotesTest < Minitest::Test
  include InvoicePrinterHelpers

  def test_setting_a_note
    params = default_document_params.merge(
      note: 'ABC is a registered trademark.'
    )
    invoice = InvoicePrinter::Document.new(**params)
    rendered_pdf = InvoicePrinter.render(document: invoice)
    pdf_analysis = PDF::Inspector::Text.analyze(rendered_pdf)

    assert_equal true, pdf_analysis.strings.include?('ABC is a registered trademark.')
  end
end
