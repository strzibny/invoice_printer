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
  end
end
