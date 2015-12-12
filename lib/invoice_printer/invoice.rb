module InvoicePrinter
  class Invoice
    attr_accessor :number,
                  # User fields
                  :business_name,
                  :business_ic,
                  :business_dic,
                  # User address fields
                  :business_street,
                  :business_street_number,
                  :business_postcode,
                  :business_city,
                  :business_city_part,
                  :business_extra_customer_line,
                  # Customer fields
                  :customer_name,
                  :customer_ic,
                  :customer_dic,
                  # Customer address fields
                  :customer_street,
                  :customer_street_number,
                  :customer_postcode,
                  :customer_city,
                  :customer_city_part,
                  :customer_extra_customer_line,
                  # Are we the ones creating the invoice?
                  :issuer,
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
                   business_name: nil,
                   business_ic: nil,
                   business_dic: nil,
                   business_street: nil,
                   business_street_number: nil,
                   business_postcode: nil,
                   business_city: nil,
                   business_city_part: nil,
                   business_extra_customer_line: nil,
                   customer_name: nil,
                   customer_ic: nil,
                   customer_dic: nil,
                   customer_street: nil,
                   customer_street_number: nil,
                   customer_postcode: nil,
                   customer_city: nil,
                   customer_city_part: nil,
                   customer_extra_customer_line: nil,
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
      @business_name = business_name
      @business_ic = business_ic
      @business_dic = business_dic
      @business_street = business_street
      @business_street_number = business_street_number
      @business_postcode = business_postcode
      @business_city = business_city
      @business_city_part = business_city_part
      @business_extra_customer_line = business_extra_customer_line
      @customer_name = customer_name
      @customer_ic = customer_ic
      @customer_dic = customer_dic
      @customer_street = customer_street
      @customer_street_number = customer_street_number
      @customer_postcode = customer_postcode
      @customer_city = customer_city
      @customer_city_part = customer_city_part
      @customer_extra_customer_line = customer_extra_customer_line
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
