module InvoicePrinter
  # Invoice and receipt representation
  #
  # Example:
  #
  #   invoice = InvoicePrinter::Document.new(
  #     number: '198900000001',
  #     provider_name: 'Business s.r.o.',
  #     provider_ic: '56565656',
  #     provider_dic: '465454',
  #     provider_street: 'Rolnicka',
  #     provider_street_number: '1',
  #     provider_postcode: '747 05',
  #     provider_city: 'Opava',
  #     provider_city_part: 'Katerinky',
  #     provider_extra_address_line: 'Czech Republic',
  #     purchaser_name: 'Adam',
  #     purchaser_ic: '',
  #     purchaser_dic: '',
  #     purchaser_street: 'Ostravska',
  #     purchaser_street_number: '1',
  #     purchaser_postcode: '747 70',
  #     purchaser_city: 'Opava',
  #     purchaser_city_part: '',
  #     purchaser_extra_address_line: '',
  #     purchaser: 'Odberatel',
  #     provider: "NecoDodavatel",
  #     issue_date: '19/03/3939',
  #     due_date: '19/03/3939',
  #     amount: '$ 200',
  #     bank_account_number: '156546546465',
  #     account_iban: 'IBAN464545645',
  #     account_swift: 'SWIFT5456',
  #     items: [
  #       InvoicePrinter::Document::Item.new,
  #       InvoicePrinter::Document::Item.new
  #     ]
  #   )
  #
  # +amount should equal the sum of all item's +amount+,
  # but this is not enforced.
  class Document
    attr_accessor :number,
                  # Provider fields
                  :provider_name,
                  :provider_ic,
                  :provider_dic,
                  # Provider address fields
                  :provider_street,
                  :provider_street_number,
                  :provider_postcode,
                  :provider_city,
                  :provider_city_part,
                  :provider_extra_address_line,
                  # Purchaser fields
                  :purchaser_name,
                  :purchaser_ic,
                  :purchaser_dic,
                  # Purchaser address fields
                  :purchaser_street,
                  :purchaser_street_number,
                  :purchaser_postcode,
                  :purchaser_city,
                  :purchaser_city_part,
                  :purchaser_extra_address_line,
                  :purchaser,
                  :provider,
                  :issue_date,
                  :due_date,
                  # Account details
                  :amount,
                  :bank_account_number,
                  :account_iban,
                  :account_swift,
                  # Collection of InvoicePrinter::Invoice::Items
                  :items

    def initialize(number: nil,
                   provider_name: nil,
                   provider_ic: nil,
                   provider_dic: nil,
                   provider_street: nil,
                   provider_street_number: nil,
                   provider_postcode: nil,
                   provider_city: nil,
                   provider_city_part: nil,
                   provider_extra_address_line: nil,
                   purchaser_name: nil,
                   purchaser_ic: nil,
                   purchaser_dic: nil,
                   purchaser_street: nil,
                   purchaser_street_number: nil,
                   purchaser_postcode: nil,
                   purchaser_city: nil,
                   purchaser_city_part: nil,
                   purchaser_extra_address_line: nil,
                   purchaser: nil,
                   provider: nil,
                   issue_date: nil,
                   due_date: nil,
                   amount: nil,
                   bank_account_number: nil,
                   account_iban: nil,
                   account_swift: nil,
                   items: nil)
      @number = number
      @provider_name = provider_name
      @provider_ic = provider_ic
      @provider_dic = provider_dic
      @provider_street = provider_street
      @provider_street_number = provider_street_number
      @provider_postcode = provider_postcode
      @provider_city = provider_city
      @provider_city_part = provider_city_part
      @provider_extra_address_line = provider_extra_address_line
      @purchaser_name = purchaser_name
      @purchaser_ic = purchaser_ic
      @purchaser_dic = purchaser_dic
      @purchaser_street = purchaser_street
      @purchaser_street_number = purchaser_street_number
      @purchaser_postcode = purchaser_postcode
      @purchaser_city = purchaser_city
      @purchaser_city_part = purchaser_city_part
      @purchaser_extra_address_line = purchaser_extra_address_line
      @purchaser = purchaser
      @provider = provider
      @issue_date = issue_date
      @due_date = due_date
      @amount = amount
      @bank_account_number = bank_account_number
      @account_iban = account_iban
      @account_swift = account_swift
      @items = items
    end
  end
end
