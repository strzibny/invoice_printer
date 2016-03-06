require 'pdf/inspector'
require 'invoice_printer'
require 'minitest/autorun'

# Add methods exposing array of attributes in order as their appear on PDF
module InvoicePrinter
  class Document::Item
    def to_a
      [
        @name,
        @quantity,
        @unit,
        @price,
        @tax,
        @tax2,
        @tax3,
        @amount
      ]
    end
  end

  class Document
    def to_a
      [
        @number,
        @provider_name,
        @provider_ic,
        @provider_dic,
        @provider_street,
        @provider_street_number,
        @provider_postcode,
        @provider_city,
        @provider_city_part,
        @provider_extra_address_line,
        @purchaser_name,
        @purchaser_ic,
        @purchaser_dic,
        @purchaser_street,
        @purchaser_street_number,
        @purchaser_postcode,
        @purchaser_city,
        @purchaser_city_part,
        @purchaser_extra_address_line,
        @purchaser,
        @provider,
        @issue_date,
        @due_date,
        @subtotal,
        @tax,
        @tax2,
        @tax3,
        @total,
        @bank_account_number,
        @account_iban,
        @account_swift,
        @items.to_a
      ]
    end
  end
end

# Helpers for easy-to-build documents
class InvoicePrinterHelper
  def self.default_document
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
      purchaser_ic: '',
      purchaser_dic: '',
      purchaser_street: 'Ostravska',
      purchaser_street_number: '1',
      purchaser_postcode: '747 70',
      purchaser_city: 'Opava',
      purchaser_city_part: '',
      purchaser_extra_address_line: '',
      purchaser: 'Odberatel',
      provider: 'NecoDodavatel',
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
        InvoicePrinter::Document::Item.new(self.default_document_item),
        InvoicePrinter::Document::Item.new(self.default_document_item),
        InvoicePrinter::Document::Item.new(self.default_document_item)
      ]
    }
  end

  def self.default_document_item
    {
      name: 'Web consultation',
      quantity: nil,
      unit: 'hours',
      price: '$ 25',
      tax: '$ 1',
      amount: '$ 100'
    }
  end
end
