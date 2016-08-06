require 'prawn'
require 'prawn/table'

module InvoicePrinter
  # Prawn PDF representation of InvoicePrinter::Document
  #
  # Example:
  #
  #   invoice = InvoicePrinter::Document.new(...)
  #   invoice_pdf = InvoicePrinter::PDFDocument.new(
  #     document: invoice,
  #     labels: {},
  #     font: 'font.ttf',
  #     logo: 'example.jpg'
  #   )
  class PDFDocument
    class FontFileNotFound < StandardError; end
    class LogoFileNotFound < StandardError; end
    class InvalidInput < StandardError; end

    attr_reader :invoice, :labels, :file_name, :font, :logo

    DEFAULT_LABELS = {
      name: 'Invoice',
      provider: 'Provider',
      purchaser: 'Purchaser',
      ic: 'Identification number',
      dic: 'Identification number',
      payment: 'Payment',
      payment_by_transfer: 'Payment by bank transfer on the account below:',
      payment_in_cash: 'Payment in cash',
      account_number: 'Account NO',
      swift: 'SWIFT',
      iban: 'IBAN',
      issue_date: 'Issue date',
      due_date: 'Due date',
      item: 'Item',
      quantity: 'Quantity',
      unit: 'Unit',
      price_per_item: 'Price per item',
      tax: 'Tax',
      tax2: 'Tax 2',
      tax3: 'Tax 3',
      amount: 'Amount',
      subtotal: 'Subtotal',
      total: 'Total'
    }

    def self.labels
      @@labels ||= DEFAULT_LABELS
    end

    def self.labels=(labels)
      @@labels = DEFAULT_LABELS.merge(labels)
    end

    def initialize(document: Document.new, labels: {}, font: nil, logo: nil)
      @document = document
      @labels = PDFDocument.labels.merge(labels)
      @pdf = Prawn::Document.new
      @font = font
      @logo = logo

      raise InvalidInput, 'document is not a type of InvoicePrinter::Document' \
        unless @document.is_a?(InvoicePrinter::Document)

      if @logo && !@logo.empty?
        if File.exist?(@logo)
          @logo = logo
        else
          raise LogoFileNotFound, "Logotype file not found at #{@logo}"
        end
      end

      if @font && !@font.empty?
        if File.exist?(@font)
          set_fonts(@font) if @font
        else
          raise FontFileNotFound, "Font file not found at #{@font}"
        end
      end

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

    # Add font family in Prawn for a given +font+ file
    def set_fonts(font)
      font_name = Pathname.new(font).basename
      @pdf.font_families.update(
        "#{font_name}" => {
          normal: font,
          italic: font,
          bold: font,
          bold_italic: font
        }
      )
      @pdf.font(font_name)
    end

    # Build the PDF version of the document (@pdf)
    def build_pdf
      @push_down = 0
      @push_items_table = 0
      @pdf.fill_color '000000'
      build_header
      build_provider_box
      build_purchaser_box
      build_payment_method_box
      build_info_box
      build_items
      build_total
      build_logo
      build_note
      build_footer
    end

    # Build the document name and number
    def build_header
      @pdf.text_box(
        @labels[:name],
        size: 20,
        at: [0, 720 - @push_down],
        width: 300,
        align: :left
      )
      @pdf.text_box(
        @document.number,
        size: 20,
        at: [240, 720 - @push_down],
        width: 300,
        align: :right
      )
      @pdf.move_down(250)
    end

    # Build the following provider box:
    #
    #    -------------------------------------
    #   | Provider                            |
    #   | PROVIDER co.                        |
    #   | 5th Street                          |
    #   | 747 27    City                      |
    #   |           Part of the city          |
    #   |                                     |
    #   | Identification number: Number       |
    #   | Identification number: Number 2     |
    #    -------------------------------------
    #
    def build_provider_box
      @pdf.text_box(
        @labels[:provider],
        size: 10,
        at: [10, 660 - @push_down],
        width: 240
      )
      @pdf.text_box(
        @document.provider_name,
        size: 14,
        at: [10, 640 - @push_down],
        width: 240
      )
      @pdf.text_box(
        "#{@document.provider_street}    #{@document.provider_street_number}",
        size: 10,
        at: [10, 620 - @push_down],
        width: 240
      )
      @pdf.text_box(
        @document.provider_postcode,
        size: 10,
        at: [10, 605 - @push_down],
        width: 240
      )
      @pdf.text_box(
        @document.provider_city,
        size: 10,
        at: [60, 605 - @push_down],
        width: 240
      )
      unless @document.provider_city_part.empty?
        @pdf.text_box(
          @document.provider_city_part,
          size: 10,
          at: [60, 590 - @push_down],
          width: 240
        )
      end
      unless @document.provider_extra_address_line.empty?
        @pdf.text_box(
          @document.provider_extra_address_line,
          size: 10,
          at: [10, 575 - @push_down],
          width: 240
        )
      end
      unless @document.provider_ic.empty?
        @pdf.text_box(
          "#{@labels[:ic]}:    #{@document.provider_ic}",
          size: 10,
          at: [10, 550 - @push_down],
          width: 240
        )
      end
      unless @document.provider_dic.empty?
        @pdf.text_box(
          "#{@labels[:dic]}:    #{@document.provider_dic}",
          size: 10,
          at: [10, 535 - @push_down],
          width: 240
        )
      end
      @pdf.stroke_rounded_rectangle([0, 670 - @push_down], 270, 150, 6)
    end

    # Build the following purchaser box:
    #
    #    -------------------------------------
    #   | Purchaser                           |
    #   | PURCHASER co.                       |
    #   | 5th Street                          |
    #   | 747 27    City                      |
    #   |           Part of the city          |
    #   |                                     |
    #   | Identification number: Number       |
    #   | Identification number: Number 2     |
    #    -------------------------------------
    #
    def build_purchaser_box
      @pdf.text_box(
        @labels[:purchaser],
        size: 10,
        at: [290, 660 - @push_down],
        width: 240
      )
      @pdf.text_box(
        @document.purchaser_name,
        size: 14,
        at: [290, 640 - @push_down],
        width: 240
      )
      @pdf.text_box(
        "#{@document.purchaser_street}    #{@document.purchaser_street_number}",
        size: 10,
        at: [290, 620 - @push_down],
        width: 240
      )
      @pdf.text_box(
        @document.purchaser_postcode,
        size: 10,
        at: [290, 605 - @push_down],
        width: 240
      )
      @pdf.text_box(
        @document.purchaser_city,
        size: 10,
        at: [340, 605 - @push_down],
        width: 240
      )
      unless @document.purchaser_city_part.empty?
        @pdf.text_box(
          @document.purchaser_city_part,
          size: 10,
          at: [340, 590 - @push_down],
          width: 240
        )
      end
      unless @document.purchaser_extra_address_line.empty?
        @pdf.text_box(
          @document.purchaser_extra_address_line,
          size: 10,
          at: [290, 575 - @push_down],
          width: 240
        )
      end
      unless @document.purchaser_ic.empty?
        @pdf.text_box(
          "#{@labels[:ic]}:    #{@document.purchaser_ic}",
          size: 10,
          at: [290, 550 - @push_down],
          width: 240
        )
      end
      unless @document.purchaser_dic.empty?
        @pdf.text_box(
          "#{@labels[:dic]}:    #{@document.purchaser_dic}",
          size: 10,
          at: [290, 535 - @push_down],
          width: 240
        )
      end
      @pdf.stroke_rounded_rectangle([280, 670 - @push_down], 270, 150, 6)
    end

    # Build the following payment box:
    #
    #    -----------------------------------------
    #   | Payment on the following bank account:  |
    #   | Number: 3920392032                      |
    #   | SWIFT: ...                              |
    #   | IBAN: ...                               |
    #    -----------------------------------------
    #
    # If the bank account number is not provided include a note about payment
    # in cash.
    def build_payment_method_box
      if @document.bank_account_number.empty?
        @pdf.text_box(
          @labels[:payment],
          size: 10,
          at: [10, 498 - @push_down],
          width: 240
        )
        @pdf.text_box(
          @labels[:payment_in_cash],
          size: 10,
          at: [10, 483 - @push_down],
          width: 240
        )
        @pdf.stroke_rounded_rectangle([0, 508 - @push_down], 270, 45, 6)
      else
        box_height = 45
        push_iban = 0
        @pdf.text_box(
          @labels[:payment_by_transfer],
          size: 10,
          at: [10, 498 - @push_down],
          width: 240
        )
        @pdf.text_box(
          "#{@labels[:account_number]}:",
          size: 10,
          at: [10, 483 - @push_down],
          width: 240
        )
        @pdf.text_box(
          @document.bank_account_number,
          size: 10,
          at: [75, 483 - @push_down],
          width: 240
        )
        unless @document.account_swift.empty?
          @pdf.text_box(
            "#{@labels[:swift]}:",
            size: 10,
            at: [10, 468 - @push_down],
            width: 240
          )
          @pdf.text_box(
            @document.account_swift,
            size: 10,
            at: [75, 468 - @push_down],
            width: 240
          )
          box_height += 15
          push_iban = 15
          @push_items_table += 15
        end
        unless @document.account_iban.empty?
          @pdf.text_box(
            "#{@labels[:iban]}:",
            size: 10,
            at: [10, 468 - push_iban - @push_down],
            width: 240
          )
          @pdf.text_box(
            @document.account_iban,
            size: 10,
            at: [75, 468 - push_iban - @push_down],
            width: 240
          )
          box_height += 15
          @push_items_table += 15
        end
        @pdf.stroke_rounded_rectangle([0, 508 - @push_down], 270, box_height, 6)
      end
    end

    # Build the following info box:
    #
    #    --------------------------------
    #   | Issue date: 03/03/2016         |
    #   | Due date: 03/03/2016           |
    #    --------------------------------
    #
    def build_info_box
      issue_date_present = !@document.issue_date.empty?
      due_date_present = !@document.due_date.empty?
      if issue_date_present
        @pdf.text_box(
          "#{@labels[:issue_date]}:",
          size: 10,
          at: [290, 498 - @push_down],
          width: 240
        )
        @pdf.text_box(
          @document.issue_date,
          size: 10,
          at: [390, 498 - @push_down],
          width: 240
        )
      end
      if due_date_present
        position = issue_date_present ? 483 : 498
        @pdf.text_box(
          "#{@labels[:due_date]}:",
          size: 10,
          at: [290, position - @push_down],
          width: 240
        )
        @pdf.text_box(
          @document.due_date,
          size: 10,
          at: [390, position - @push_down],
          width: 240
        )
      end
      if issue_date_present || due_date_present
        height = (issue_date_present && due_date_present) ? 45 : 30
        @pdf.stroke_rounded_rectangle([280, 508 - @push_down], 270, height, 6)
      end
    end

    # Build the following table for document items:
    #
    #   =================================================================
    #   |Item | Quantity | Unit | Price per item | Tax | Total per item |
    #   |-----|----------|------|----------------|-----|----------------|
    #   | x   | 2        | hr   | $ 2            | $1  | $ 4            |
    #   =================================================================
    #
    # If a specific column miss data, it's omittted.
    # Tax2 and tax3 fields can be added as well if necessary.
    def build_items
      @pdf.move_down(25 + @push_items_table + @push_down)

      items_params = determine_items_structure
      items = build_items_data(items_params)
      headers = build_items_header(items_params)

      styles = {
        headers: headers,
        row_colors: ['F5F5F5', nil],
        width: 550,
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

      @pdf.table(items, styles) unless items.empty?
    end

    # Determine sections of the items table to show based on provided data
    def determine_items_structure
      items_params = {}
      @document.items.each do |item|
        items_params[:names] = true unless item.name.empty?
        items_params[:quantities] = true unless item.quantity.empty?
        items_params[:units] = true unless item.unit.empty?
        items_params[:prices] = true unless item.price.empty?
        items_params[:taxes] = true unless item.tax.empty?
        items_params[:taxes2] = true unless item.tax2.empty?
        items_params[:taxes3] = true unless item.tax3.empty?
        items_params[:amounts] = true unless item.amount.empty?
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
      items << ["#{@labels[:subtotal]}:", @document.subtotal] unless @document.subtotal.empty?
      items << ["#{@labels[:tax]}:", @document.tax] unless @document.tax.empty?
      items << ["#{@labels[:tax2]}:", @document.tax2] unless @document.tax2.empty?
      items << ["#{@labels[:tax3]}:", @document.tax3] unless @document.tax3.empty?

      width = [
        "#{@labels[:subtotal]}#{@document.subtotal}".size,
        "#{@labels[:tax]}#{@document.tax}".size,
        "#{@labels[:tax2]}#{@document.tax2}".size,
        "#{@labels[:tax3]}#{@document.tax3}".size
      ].max * 7

      styles = {
        border_width: 0,
        align: {
          0 => :right,
          1 => :left
        }
      }

      @pdf.span(width, position: :right) do
        @pdf.table(items, styles) unless items.empty?
      end

      @pdf.move_down(15)

      @pdf.text(
        "#{@labels[:total]}:   #{@document.total}",
        size: 16,
        align: :right,
        style: :bold
      )
    end

    # Insert a logotype at the left bottom of the document
    #
    # If a note is present, position it on top of it.
    def build_logo
      bottom = @document.note.empty? ? 50 : 60
      @pdf.image(@logo, at: [0, bottom]) if @logo && !@logo.empty?
    end

    # Note at the end
    def build_note
      @pdf.text_box(
        "#{@document.note}",
        size: 10,
        at: [0, 10],
        width: 450,
        align: :left
      )
    end

    # Include page numbers if we got more than one page
    def build_footer
      @pdf.number_pages(
        '<page> / <total>',
        start_count_at: 1,
        page_filter: ->(page) { page != 1 },
        at: [@pdf.bounds.right - 50, 0],
        align: :right,
        size: 12
      )
    end
  end
end
