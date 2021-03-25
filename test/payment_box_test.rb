require 'test_helper'

class PaymentBoxTest < Minitest::Test
  include InvoicePrinterHelpers

  def test_setting_no_bank_account_number
    params = default_document_params.merge(
      bank_account_number: nil,
      account_iban: 'IBAN'
    )
    invoice = InvoicePrinter::Document.new(**params)
    rendered_pdf = InvoicePrinter.render(document: invoice)
    pdf_analysis = PDF::Inspector::Text.analyze(rendered_pdf)

    assert_equal true, pdf_analysis.strings.include?('Payment in cash')
    assert_equal false, pdf_analysis.strings.include?('Payment by bank transfer on the account below:')
    assert_equal false, pdf_analysis.strings.include?('SWIFT')
    assert_equal false, pdf_analysis.strings.include?('IBAN')
  end

  def test_setting_only_local_bank_account_number
    params = default_document_params.merge(
      bank_account_number: '218291829/0100',
      account_iban: nil,
      account_swift: nil
    )
    invoice = InvoicePrinter::Document.new(**params)
    rendered_pdf = InvoicePrinter.render(document: invoice)
    pdf_analysis = PDF::Inspector::Text.analyze(rendered_pdf)

    assert_equal false, pdf_analysis.strings.include?('Payment in cash')
    assert_equal true, pdf_analysis.strings.include?('Payment by bank transfer on the account below:')
    assert_equal true, pdf_analysis.strings.include?('218291829/0100')
    assert_equal false, pdf_analysis.strings.include?('SWIFT')
    assert_equal false, pdf_analysis.strings.include?('IBAN')
  end

  def test_setting_bank_account_number_and_iban
    params = default_document_params.merge(
      bank_account_number: '218291829/0100',
      account_iban: 'SAMPLE_IBAN',
      account_swift: nil
    )
    invoice = InvoicePrinter::Document.new(**params)
    rendered_pdf = InvoicePrinter.render(document: invoice)
    pdf_analysis = PDF::Inspector::Text.analyze(rendered_pdf)

    assert_equal false, pdf_analysis.strings.include?('Payment in cash')
    assert_equal true, pdf_analysis.strings.include?('Payment by bank transfer on the account below:')
    assert_equal true, pdf_analysis.strings.include?('218291829/0100')
    assert_equal false, pdf_analysis.strings.include?('SWIFT')
    assert_equal true, pdf_analysis.strings.include?('IBAN')
    assert_equal true, pdf_analysis.strings.include?('SAMPLE_IBAN')
  end

  def test_setting_bank_account_number_and_iban
    params = default_document_params.merge(
      bank_account_number: '218291829/0100',
      account_iban: nil,
      account_swift: 'SAMPLE_SWIFT'
    )
    invoice = InvoicePrinter::Document.new(**params)
    rendered_pdf = InvoicePrinter.render(document: invoice)
    pdf_analysis = PDF::Inspector::Text.analyze(rendered_pdf)

    assert_equal false, pdf_analysis.strings.include?('Payment in cash')
    assert_equal true, pdf_analysis.strings.include?('Payment by bank transfer on the account below:')
    assert_equal true, pdf_analysis.strings.include?('218291829/0100')
    assert_equal true, pdf_analysis.strings.include?('SWIFT')
    assert_equal true, pdf_analysis.strings.include?('SAMPLE_SWIFT')
    assert_equal false, pdf_analysis.strings.include?('IBAN')
  end

  def test_setting_bank_account_number_iban_and_swift
    params = default_document_params.merge(
      bank_account_number: '218291829/0100',
      account_iban: 'SAMPLE_IBAN',
      account_swift: 'SAMPLE_SWIFT'
    )
    invoice = InvoicePrinter::Document.new(**params)
    rendered_pdf = InvoicePrinter.render(document: invoice)
    pdf_analysis = PDF::Inspector::Text.analyze(rendered_pdf)

    assert_equal false, pdf_analysis.strings.include?('Payment in cash')
    assert_equal true, pdf_analysis.strings.include?('Payment by bank transfer on the account below:')
    assert_equal true, pdf_analysis.strings.include?('218291829/0100')
    assert_equal true, pdf_analysis.strings.include?('SWIFT')
    assert_equal true, pdf_analysis.strings.include?('SAMPLE_SWIFT')
    assert_equal true, pdf_analysis.strings.include?('IBAN')
    assert_equal true, pdf_analysis.strings.include?('SAMPLE_IBAN')
  end
end
