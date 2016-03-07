require 'pdf/inspector'
require 'invoice_printer'
require 'test_ext'
require 'minitest/autorun'

# Helpers for easy-to-build documents
module InvoicePrinterHelpers
  def default_document_params
    {
      number: '198900000001',
      provider_name: 'Business s.r.o.',
      provider_ic: '56565656',
      provider_dic: '465454',
      provider_street: 'Rolnicka',
      provider_street_number: '1',
      provider_postcode: '747 05',
      provider_city: 'Opava',
      provider_city_part: 'Katerinky',
      provider_extra_address_line: 'Czech Republic',
      purchaser_name: 'Adam',
      purchaser_ic: nil,
      purchaser_dic: nil,
      purchaser_street: 'Ostravska',
      purchaser_street_number: '1',
      purchaser_postcode: '747 70',
      purchaser_city: 'Opava',
      purchaser_city_part: '',
      purchaser_extra_address_line: '',
      issue_date: '19/03/3939',
      due_date: '19/03/3939',
      subtotal: '175',
      tax: '5',
      tax2: '10',
      tax3: '20',
      total: '$ 200',
      bank_account_number: '156546546465',
      account_iban: 'IBAN464545645',
      account_swift: 'SWIFT5456',
      items: [
        InvoicePrinter::Document::Item.new(
          default_document_item_params
        )
      ]
    }
  end

  def default_document_item_params
    {
      name: 'Web consultation',
      quantity: '2',
      unit: 'hours',
      price: '$ 25',
      tax: '$ 1',
      amount: '$ 100'
    }
  end
end
