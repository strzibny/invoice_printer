require 'test_helper'

class DatesBoxTest < Minitest::Test
  include InvoicePrinterHelpers

  def test_setting_issue_date_and_due_date
    params = default_document_params.merge(
      issue_date: '05/03/2016',
      due_date: '14/03/2016'
    )
    invoice = InvoicePrinter::Document.new(**params)
    rendered_pdf = InvoicePrinter.render(document: invoice)
    pdf_analysis = PDF::Inspector::Text.analyze(rendered_pdf)

    assert_equal true, pdf_analysis.strings.include?('Issue date')
    assert_equal true, pdf_analysis.strings.include?('Due date')
  end

  def test_setting_only_issue_date
    params = default_document_params.merge(
      issue_date: '05/03/2016',
      due_date: ''
    )
    invoice = InvoicePrinter::Document.new(**params)
    rendered_pdf = InvoicePrinter.render(document: invoice)
    pdf_analysis = PDF::Inspector::Text.analyze(rendered_pdf)

    assert_equal true, pdf_analysis.strings.include?('Issue date')
    assert_equal false, pdf_analysis.strings.include?('Due date')
  end

  def test_setting_only_due_date
    params = default_document_params.merge(
      issue_date: nil,
      due_date: '05/03/2016'
    )
    invoice = InvoicePrinter::Document.new(**params)
    rendered_pdf = InvoicePrinter.render(document: invoice)
    pdf_analysis = PDF::Inspector::Text.analyze(rendered_pdf)

    assert_equal false, pdf_analysis.strings.include?('Issue date')
    assert_equal true, pdf_analysis.strings.include?('Due date')
  end

  def test_setting_no_dates
    params = default_document_params.merge(
      issue_date: '',
      due_date: nil
    )
    invoice = InvoicePrinter::Document.new(**params)
    rendered_pdf = InvoicePrinter.render(document: invoice)
    pdf_analysis = PDF::Inspector::Text.analyze(rendered_pdf)

    assert_equal false, pdf_analysis.strings.include?('Issue date')
    assert_equal false, pdf_analysis.strings.include?('Due date')
  end
end
