module InvoicePrinter
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
                   issuer: true,
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
      @issuer = issuer
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
