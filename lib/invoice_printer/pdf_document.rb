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
    attr_reader :invoice, :labels, :file_name

    DEFAULT_LABELS = {
      name: 'Invoice',
      provider: 'Provider',
      purchaser: 'Purchaser',
      ic: 'Identification number',
      dic: 'Identification number',
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
      subtotal: 'Subtotal',
      tax: 'Tax',
      tax2: 'Tax 2',
      tax3: 'Tax 3',
      amount: 'Amount',
      total: 'Amount'
    }

    def self.labels
      @@labels ||= DEFAULT_LABELS
    end

    def self.labels=(labels)
      @@labels = DEFAULT_LABELS.merge(labels)
    end

    def initialize(document: Document.new, labels: {})
      @document = document
      @labels = PDFDocument.labels.merge(labels)
      @pdf = Prawn::Document.new
      build_pdf
    end

    # Create PDF file named +file_name+
    def print(file_name = 'invoice.pdf')
      @pdf.render_file file_name
    end

    # Directly render the PDF
    def render
      @pdf.render
    end

    private

    def build_pdf
      @push_down = 40
      @pdf.fill_color '000000'
      build_header
      build_provider_box
      build_purchaser_box
      build_payment_method_box
      build_info_box
      build_items
      build_total
      build_footer
    end

    def build_header
      @pdf.text @labels[:name], size: 20
      @pdf.text_box(
        @document.number,
        size: 20,
        at: [240, 720],
        width: 300,
        align: :right
      )
      @pdf.move_down(250)
    end

    def build_provider_box
      @pdf.text_box(
        @labels[:provider],
        size: 10,
        at: [10, 660],
        width: 240
      )
      @pdf.text_box(
        @document.provider_name,
        size: 14,
        at: [10, 640],
        width: 240
      )
      @pdf.text_box(
        "#{@document.provider_street}    #{@document.provider_street_number}",
        size: 10,
        at: [10, 620],
        width: 240
      )
      @pdf.text_box(
        @document.provider_postcode,
        size: 10,
        at: [10, 605],
        width: 240
      )
      @pdf.text_box(
        @document.provider_city,
        size: 10,
        at: [60, 605],
        width: 240
      )
      @pdf.text_box(
        @document.provider_city_part,
        size: 10,
        at: [60, 590],
        width: 240
      )
      @pdf.text_box(
        @document.provider_extra_address_line,
        size: 10,
        at: [10, 575],
        width: 240
      )
      @pdf.text_box(
        "#{@labels[:ic]}    #{@document.provider_ic}",
        size: 10,
        at: [10, 550],
        width: 240
      )
      @pdf.text_box(
        "#{@labels[:dic]}    #{@document.provider_dic}",
        size: 10,
        at: [10, 535],
        width: 240
      )
    end

    def build_purchaser_box
      @pdf.text_box(
        @labels[:purchaser],
        size: 10,
        at: [290, 660],
        width: 240
      )
      @pdf.text_box(
        @document.purchaser_name,
        size: 14,
        at: [290, 640],
        width: 240
      )
      @pdf.text_box(
        "#{@document.purchaser_street}    #{@document.purchaser_street_number}",
        size: 10,
        at: [290, 620],
        width: 240
      )
      @pdf.text_box(
        @document.purchaser_postcode,
        size: 10,
        at: [290, 605],
        width: 240
      )
      @pdf.text_box(
        @document.purchaser_city,
        size: 10,
        at: [340, 605],
        width: 240
      )
      @pdf.text_box(
        @document.purchaser_city_part,
        size: 10,
        at: [340, 590],
        width: 240
      )
      @pdf.text_box(
        @document.purchaser_extra_address_line,
        size: 10,
        at: [290, 575],
        width: 240
      )

      move_down = 0
      move_down += 15 unless @document.purchaser_city_part.nil?
      move_down += 15 unless @document.purchaser_extra_address_line.nil?

      @pdf.stroke_rounded_rectangle([0, 670], 270, 150, 6)
      @pdf.stroke_rounded_rectangle([280, 670], 270, 150, 6)

      if @document.purchaser_ic.nil? && @document.purchaser_dic.nil?
        # Just skip for now
      elsif !@document.purchaser_dic.nil?
        @pdf.text_box(
          "#{@labels[:dic]}    #{@document.purchaser_dic}",
          size: 10,
          at: [290, 565 - move_down],
          width: 240
        )
      elsif !@document.purchaser_ic.nil?
        @pdf.text_box(
          "#{@labels[:ic]}    #{@document.purchaser_ic}",
          size: 10,
          at: [290, 565 - move_down],
          width: 240
        )
      else
        @pdf.text_box(
          "#{@labels[:ic]}    #{@document.purchaser_ic}    #{@labels[:dic]}:    #{@document.purchaser_dic}",
          size: 10,
          at: [290, 565],
          width: 240
        )
      end
    end

    def build_payment_method_box
      if @document.bank_account_number.nil?
        @pdf.stroke_rounded_rectangle([0, 540 - @push_down], 270, 45, 6)
        @pdf.text_box(
          @labels[:payment],
          size: 10,
          at: [10, 530 - @push_down],
          width: 240
        )
        @pdf.text_box(
          @labels[:payment_in_cash],
          size: 10,
          at: [10, 515 - @push_down],
          width: 240
        )
        return
      end

      # TODO: @pdf.text @document.bank_account_number

      if @document.account_swift.nil? || @document.account_swift.nil?
        @pdf.stroke_rounded_rectangle([0, 540 - @push_down], 270, 45, 6)
        @pdf.text_box(
          @labels[:payment],
          size: 10,
          at: [10, 530 - @push_down],
          width: 240
        )
        @pdf.text_box(
          @document.account_name,
          size: 10,
          at: [10, 515 - @push_down],
          width: 240
        )
      else
        @pdf.stroke_rounded_rectangle([0, 540 - @push_down], 270, 75, 6)
        @pdf.text_box(
          @labels[:payment_by_transfer],
          size: 10,
          at: [10, 530 - @push_down],
          width: 240
        )
        @pdf.text_box(
          @labels[:account_number],
          size: 10,
          at: [10, 515 - @push_down],
          width: 240
        )
        @pdf.text_box(
          @document.bank_account_number,
          size: 10,
          at: [75, 515 - @push_down],
          width: 240
        )
        @pdf.text_box(
          @labels[:swift],
          size: 10,
          at: [10, 500 - @push_down],
          width: 240
        )
        @pdf.text_box(
          @document.account_swift,
          size: 10,
          at: [75, 500 - @push_down],
          width: 240
        )
        @pdf.text_box(
          @labels[:iban],
          size: 10,
          at: [10, 485 - @push_down],
          width: 240
        )
        @pdf.text_box(
          @document.account_iban,
          size: 10,
          at: [75, 485 - @push_down],
          width: 240
        )
      end
    end

    def build_info_box
      @pdf.stroke_rounded_rectangle([280, 540 - @push_down], 270, 45, 6)
      @pdf.text_box(
        @labels[:issue_date],
        size: 10,
        at: [290, 530 - @push_down],
        width: 240
      )
      @pdf.text_box(
        @document.issue_date,
        size: 10,
        at: [390, 530 - @push_down],
        width: 240
      )
      @pdf.text_box(
        @labels[:due_date],
        size: 10,
        at: [290, 515 - @push_down],
        width: 240
      )
      @pdf.text_box(
        @document.due_date,
        size: 10,
        at: [390, 515 - @push_down],
        width: 240
      )
    end

    # Build the following table for document items:
    #
    #   |===============================================================|
    #   |Item | Quantity | Unit | Price per item | Tax | Total per item |
    #   |-----|----------|------|----------------|-----|----------------|
    #   | x   | 2        | hr   | $ 2            | $1  | $ 4            |
    #   |===============================================================|
    #
    # If a specific column miss data, it's omittted.
    # Tax2 and tax3 fields can be added as well if necessary.
    def build_items
      @pdf.move_down(25 + @push_down)

      items_params = determine_items_structure
      items = build_items_data(items_params)
      headers = build_items_header(items_params)

      styles = {
        headers: headers,
        align: {
          0 => :left,
          1 => :right,
          2 => :right,
          3 => :right,
          4 => :right,
          5 => :right,
          6 => :right,
          7 => :right
        }
      }

      @pdf.table(items, styles)
    end

    # Determine sections of the items table to show based on provided data
    def determine_items_structure
      items_params = {}

      @document.items.each do |item|
        items_params[:names] = true if item.name
        items_params[:quantities] = true if item.quantity
        items_params[:units] = true if item.unit
        items_params[:prices] = true if item.price
        items_params[:taxes] = true if item.tax
        items_params[:taxes2] = true if item.tax2
        items_params[:taxes3] = true if item.tax3
        items_params[:amounts] = true if item.amount
      end

      items_params
    end

    # Include only items params with provided data
    def build_items_data(items_params)
      @document.items.map do |item|
        line = []
        line << item.name if items_params[:names]
        line << item.quantity if items_params[:quantities]
        line << item.unit if items_params[:units]
        line << item.price if items_params[:prices]
        line << item.tax if items_params[:taxes]
        line << item.tax2 if items_params[:taxes2]
        line << item.tax3 if items_params[:taxes3]
        line << item.amount if items_params[:amounts]
        line
      end
    end

    # Include only relevant headers
    def build_items_header(items_params)
      headers = []
      headers << { text: @labels[:item] } if items_params[:names]
      headers << { text: @labels[:quantity] } if items_params[:quantities]
      headers << { text: @labels[:unit] } if items_params[:units]
      headers << { text: @labels[:price_per_item] } if items_params[:prices]
      headers << { text: @labels[:tax] } if items_params[:taxes]
      headers << { text: @labels[:tax2] } if items_params[:taxes2]
      headers << { text: @labels[:tax3] } if items_params[:taxes3]
      headers << { text: @labels[:amount] } if items_params[:amounts]
      headers
    end

    # Build the following summary:
    #
    #   Subtotal: 175
    #        Tax: 5
    #      Tax 2: 10
    #      Tax 3: 20
    #
    #      Total: $ 200
    #
    # The first part is implemented as a table without borders.
    def build_total
      @pdf.move_down(25)

      items = []
      items << [@labels[:subtotal],  @document.subtotal]
      items << [@labels[:tax], @document.tax]
      items << [@labels[:tax2], @document.tax2]
      items << [@labels[:tax3], @document.tax3]

      styles = {
        border_width: 0,
        align: {
          0 => :right,
          1 => :left
        }
      }

      # TODO: count the width by largest label and value combination
      @pdf.span(150, position: :right) do
        @pdf.table(items, styles)
      end

      @pdf.move_down(10)

      @pdf.span(88, position: :right) do
        @pdf.text(@document.total, size: 16, style: :bold)
      end
    end

    # Include page numbers if we got more than one page
    def build_footer
      @pdf.number_pages(
        '<page> / <total>',
        start_count_at: 1,
        page_filter: ->(page) { page != 0 },
        at: [@pdf.bounds.right - 50, 0],
        align: :right,
        size: 12
      )
    end
  end
end
