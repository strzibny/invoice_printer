require 'prawn'
require 'prawn/table'

module InvoicePrinter
  # Prawn PDF representation of InvoicePrinter::Document
  #
  # Example:
  #
  #   invoice = InvoicePrinter::Document.new(...)
  #   invoice_pdf = InvoicePrinter::PDFDocument.new(invoice)
  class PDFDocument
    attr_reader :invoice, :file_name

    @@labels = {
      provider: 'Provider',
      purchaser: 'Purchaser',
      payment: 'Payment',
      payment_by_transfer: 'Payment by bank transfer on the account below:',
      payment_in_cash: 'Payment in cash',
      account_number: 'Account NO:',
      swift: 'SWIFT:',
      iban: 'IBAN:',
      issue_date: 'Issue date:',
      due_date: 'Due date:',
      item: 'Item',
      quantity: 'Quantity',
      unit: 'Unit',
      price_per_item: 'Price per item',
      tax: 'Tax',
      tax2: 'Tax 2',
      tax3: 'Tax 3',
      amount: 'Amount'
    }

    def self.labels
      @@labels
    end

    # Override default English labels with a given hash
    def self.labels=(labels)
      @@labels = @@labels.merge(labels)
    end

    def initialize(invoice = Invoice.new)
      @invoice = invoice
      @file_name = file_name
      @pdf = Prawn::Document.new

      @push_down = 40
      build_pdf
    end

    def labels
      PDFDocument.labels
    end

    # Create PDF file named +file_name+
    def print(file_name = 'invoice.pdf')
      @pdf.render_file file_name
    end

    private

    def build_pdf
      build_header
      build_provider_box
      build_purchaser_box
      build_payment_method_box
      build_info_box
      build_items

      @pdf.move_down(25)
      build_total

      build_footer
    end

    def build_header
      @pdf.text 'Faktura', size: 20

      @pdf.fill_color '000000'
      @pdf.text_box @invoice.number, size: 20, at: [240, 720], width: 300, align: :right

      @pdf.move_down(250)

      @pdf.fill_color '000000'
    end

    def build_provider_box
      # business
      @pdf.stroke_color '000000'
      @pdf.fill_color '000000'
      @pdf.text_box labels[:provider], size: 10, at: [10, 660], width: 240
      @pdf.fill_color '000000'
      @pdf.text_box @invoice.provider_name, size: 14, at: [10, 640], width: 240
      @pdf.text_box "#{@invoice.provider_street}    #{@invoice.provider_street_number}", size: 10, at: [10, 620], width: 240
      @pdf.text_box @invoice.provider_postcode, size: 10, at: [10, 605], width: 240
      @pdf.text_box @invoice.provider_city, size: 10, at: [60, 605], width: 240
      @pdf.text_box @invoice.provider_city_part, size: 10, at: [60, 590], width: 240
      @pdf.text_box @invoice.provider_extra_address_line, size: 10, at: [10, 575], width: 240

      # @pdf.fill_color "000000"
      # if there is extra address line, move
      @pdf.text_box "#{labels[:ic]}    #{@invoice.provider_ic}", size: 10, at: [10, 550], width: 240
      # move if there is dic
      @pdf.text_box "#{labels[:dic]}    #{@invoice.provider_dic}", size: 10, at: [10, 535], width: 240
    end

    def build_purchaser_box
      # Customer
      @pdf.fill_color '000000'
      @pdf.text_box labels[:purchaser], size: 10, at: [290, 660], width: 240
      @pdf.fill_color '000000'
      @pdf.text_box @invoice.purchaser_name, size: 14, at: [290, 640], width: 240
      @pdf.text_box "#{@invoice.purchaser_street}    #{@invoice.purchaser_street_number}", size: 10, at: [290, 620], width: 240
      @pdf.text_box @invoice.purchaser_postcode, size: 10, at: [290, 605], width: 240
      @pdf.text_box @invoice.purchaser_city, size: 10, at: [340, 605], width: 240
      @pdf.text_box @invoice.purchaser_city_part, size: 10, at: [340, 590], width: 240
      @pdf.text_box @invoice.purchaser_extra_address_line, size: 10, at: [290, 575], width: 240

      move_down = 0

      move_down += 15 unless @invoice.purchaser_city_part.nil?

      move_down += 15 unless @invoice.purchaser_extra_address_line.nil?

      @pdf.stroke_rounded_rectangle [0, 670], 270, 150, 6
      @pdf.stroke_rounded_rectangle [280, 670], 270, 150, 6

      # @pdf.fill_color "000000"
      if @invoice.purchaser_ic.nil? && @invoice.purchaser_dic.nil?
      elsif !@invoice.purchaser_dic.nil?
        @pdf.text_box "#{labels[:dic]}    #{@invoice.purchaser_dic}", size: 10, at: [290, 565 - move_down], width: 240
      elsif !@invoice.purchaser_ic.nil?
        @pdf.text_box "#{labels[:ic]}    #{@invoice.purchaser_ic}", size: 10, at: [290, 565 - move_down], width: 240
      else
        @pdf.text_box "#{labels[:ic]}    #{@invoice.purchaser_ic}    #{labels[:dic]}:    #{@invoice.purchaser_dic}", size: 10, at: [290, 565], width: 240
      end
    end

    def build_payment_method_box
      # Account
      unless @invoice.bank_account_number.nil?
        # @pdf.text @invoice.bank_account_number

        @pdf.fill_color '000000'

        if @invoice.account_swift.nil? || @invoice.account_swift.nil?
          @pdf.stroke_rounded_rectangle [0, 540 - @push_down], 270, 45, 6
          @pdf.text_box labels[:payment], size: 10, at: [10, 530 - @push_down], width: 240
          @pdf.text_box @invoice.account_name, size: 10, at: [10, 515 - @push_down], width: 240
        else
          @pdf.stroke_rounded_rectangle [0, 540 - @push_down], 270, 75, 6
          @pdf.text_box labels[:payment_by_transfer], size: 10, at: [10, 530 - @push_down], width: 240
          @pdf.text_box labels[:account_number], size: 10, at: [10, 515 - @push_down], width: 240
          @pdf.text_box @invoice.bank_account_number, size: 10, at: [75, 515 - @push_down], width: 240
          @pdf.text_box labels[:swift], size: 10, at: [10, 500 - @push_down], width: 240
          @pdf.text_box @invoice.account_swift, size: 10, at: [75, 500 - @push_down], width: 240
          @pdf.text_box labels[:iban], size: 10, at: [10, 485 - @push_down], width: 240
          @pdf.text_box @invoice.account_iban, size: 10, at: [75, 485 - @push_down], width: 240
        end
      else
        @pdf.stroke_rounded_rectangle [0, 540 - @push_down], 270, 45, 6
        @pdf.text_box labels[:payment], size: 10, at: [10, 530 - @push_down], width: 240
        @pdf.text_box labels[:payment_in_cash], size: 10, at: [10, 515 - @push_down], width: 240
      end
    end

    def build_info_box
      # Info

      @pdf.stroke_rounded_rectangle [280, 540 - @push_down], 270, 45, 6
      @pdf.text_box labels[:issue_date], size: 10, at: [290, 530 - @push_down], width: 240
      @pdf.text_box @invoice.issue_date, size: 10, at: [390, 530 - @push_down], width: 240
      @pdf.text_box labels[:due_date], size: 10, at: [290, 515 - @push_down], width: 240
      @pdf.text_box @invoice.due_date, size: 10, at: [390, 515 - @push_down], width: 240
    end

    # Build the following table for document items:
    #
    # |===============================================================|
    # |Item | Quantity | Unit | Price per item | Tax | Total per item |
    # |-----|----------|------|----------------|-----|----------------|
    # | x   | 2        | hr   | $ 2            | $1  | $ 4            |
    # |===============================================================|
    #
    # If a specific column miss data, it's omittted.
    def build_items
      @pdf.move_down(25 + @push_down)

      items_params = determine_items_structure
      items = build_items_data(items_params)
      headers = build_items_header(items_params)

      @pdf.table(items, headers: headers) do |_table|
      end
    end

    # Determine sections of the items table to show based on provided data
    def determine_items_structure
      items_params = {}

      @invoice.items.each do |item|
        items_params[:names] = true if item.name
        items_params[:quantities] = true if item.quantity
        items_params[:units] = true if item.unit
        items_params[:prices] = true if item.price
        items_params[:tax] = true if item.tax
        items_params[:tax2] = true if item.tax2
        items_params[:tax3] = true if item.tax3
        items_params[:amounts] = true if item.amount
      end

      items_params
    end

    # Include only items params with provided data
    def build_items_data(items_params)
      @invoice.items.map do |item|
        line = []
        line << item.name if items_params[:names]
        line << item.quantity if items_params[:quantities]
        line << item.unit if items_params[:units]
        line << item.price if items_params[:prices]
        line << item.tax if items_params[:tax]
        line << item.tax2 if items_params[:tax2]
        line << item.tax3 if items_params[:tax3]
        line << item.amount if items_params[:amounts]
        line
      end
    end

    # Include only relevant headers
    def build_items_header(items_params)
      headers = []
      headers << { text: labels[:item] } if items_params[:names]
      headers << { text: labels[:quantity] } if items_params[:quantities]
      headers << { text: labels[:unit] } if items_params[:units]
      headers << { text: labels[:price_per_item] } if items_params[:prices]
      headers << { text: labels[:tax] } if items_params[:tax]
      headers << { text: labels[:tax2] } if items_params[:tax2]
      headers << { text: labels[:tax3] } if items_params[:tax3]
      headers << { text: labels[:amount] } if items_params[:amounts]
      headers
    end

    def build_total
      @pdf.text @invoice.amount, size: 16, style: :bold
    end

    def build_footer
    end
  end
end
