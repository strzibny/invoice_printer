require 'pdf/inspector'
require 'invoice_printer'
require 'minitest/autorun'

# Add methods exposing array of attributes in order as their appear on PDF
module InvoicePrinter
  class PDFDocument
    def to_a
      strings = []

      strings << @labels[:name]
      strings << @document.number

      strings << @labels[:provider]
      strings << @document.provider_name
      strings << "#{@document.provider_street}    #{@document.provider_street_number}".strip
      strings << @document.provider_postcode
      strings << @document.provider_city
      strings << @document.provider_city_part
      strings << @document.provider_extra_address_line

      strings << "#{@labels[:ic]}    #{@document.provider_ic}" unless @document.provider_ic.nil?
      strings << "#{@labels[:dic]}    #{@document.provider_dic}" unless @document.provider_dic.nil?

      strings << @labels[:purchaser]
      strings << @document.purchaser_name
      strings << "#{@document.purchaser_street}    #{@document.purchaser_street_number}".strip
      strings << @document.purchaser_postcode
      strings << @document.purchaser_city
      strings << @document.purchaser_city_part
      strings << @document.purchaser_extra_address_line

      strings << "#{@labels[:ic]}    #{@document.purchaser_ic}" unless @document.purchaser_ic.nil?
      strings << "#{@labels[:dic]}    #{@document.purchaser_dic}" unless @document.purchaser_dic.nil?

      #strings << @labels[:payment]
      if @document.bank_account_number.nil?
        strings << @labels[:payment_in_cash]
      else
        strings << @labels[:payment_by_transfer]
      end

      strings << @labels[:account_number]
      strings << @document.bank_account_number
      strings << @labels[:swift]
      strings << @document.account_swift
      strings << @labels[:iban]
      strings << @document.account_iban

      strings << @labels[:issue_date]
      strings << @document.issue_date
      strings << @labels[:due_date]
      strings << @document.due_date

      strings << @labels[:item]
      #strings << @labels[:quantity]
      strings << @labels[:unit]
      strings << @labels[:price_per_item]
      strings << @labels[:tax]
      strings << @labels[:amount]
      strings << items_to_a(@document.items)

      strings << @labels[:subtotal]
      strings << @document.subtotal
      strings << @labels[:tax]
      strings << @document.tax
      strings << @labels[:tax2]
      strings << @document.tax2
      strings << @labels[:tax3]
      strings << @document.tax3
      strings << @document.total
      # Pages
      strings << '1 / 1'
      strings.flatten.reject(&:empty?)
    end

    def items_to_a(items)
      ary = []
      items.each do |item|
        ary << item_to_a(item)
      end
      ary.flatten
    end

    def item_to_a(item)
      ary = []
      ary << item.name
      ary << item.quantity
      ary << item.unit
      ary << item.price
      ary << item.tax
      ary << item.tax2
      ary << item.tax3
      ary << item.amount
      ary.compact
    end
  end
end

# Helpers for easy-to-build @documents
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
        InvoicePrinter::Document::Item.new(default_document_item_params),
        InvoicePrinter::Document::Item.new(default_document_item_params),
        InvoicePrinter::Document::Item.new(default_document_item_params)
      ]
    }
  end

  def default_document_item_params
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
