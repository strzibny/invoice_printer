module InvoicePrinter
  class PDFDocument
    # Expose the document as an array of attributes in order as their
    # appear on PDF
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

      # Account
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

      # Dates
      strings << @labels[:issue_date]
      strings << @document.issue_date
      strings << @labels[:due_date]
      strings << @document.due_date

      # Items table
      strings << @labels[:item] if determine_items_structure[:names]
      strings << @labels[:quantity] if determine_items_structure[:quantities]
      strings << @labels[:unit] if determine_items_structure[:units]
      strings << @labels[:price_per_item] if determine_items_structure[:prices]
      strings << @labels[:tax] if determine_items_structure[:taxes]
      strings << @labels[:amount] if determine_items_structure[:amounts]
      strings << items_to_a(@document.items)

      # Total table
      strings << @labels[:subtotal]
      strings << @document.subtotal
      strings << @labels[:tax]
      strings << @document.tax
      strings << @labels[:tax2]
      strings << @document.tax2
      strings << @labels[:tax3]
      strings << @document.tax3
      strings << "#{@labels[:total]}   #{@document.total}"

      # TODO: dynamically test page numbers
      strings << '1 / 1'

      strings.flatten.reject(&:empty?)
    end

    private

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
