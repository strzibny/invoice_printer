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
  #     bold_font: 'bold_font.ttf',
  #     stamp: 'stamp.jpg',
  #     logo: 'example.jpg'
  #   )
  class PDFDocument
    class FontFileNotFound < StandardError; end
    class LogoFileNotFound < StandardError; end
    class StampFileNotFound < StandardError; end
    class InvalidInput < StandardError; end

    attr_reader :invoice, :labels, :file_name, :font, :bold_font, :stamp, :logo

    DEFAULT_LABELS = {
      name: 'Invoice',
      provider: 'Provider',
      purchaser: 'Purchaser',
      tax_id: 'Identification number',
      tax_id2: 'Identification number',
      payment: 'Payment',
      payment_by_transfer: 'Payment by bank transfer on the account below:',
      payment_in_cash: 'Payment in cash',
      account_number: 'Account NO',
      swift: 'SWIFT',
      iban: 'IBAN',
      issue_date: 'Issue date',
      due_date: 'Due date',
      variable_symbol: 'Variable symbol',
      item: 'Item',
      variable: '',
      quantity: 'Quantity',
      unit: 'Unit',
      price_per_item: 'Price per item',
      tax: 'Tax',
      tax2: 'Tax 2',
      tax3: 'Tax 3',
      amount: 'Amount',
      subtotal: 'Subtotal',
      total: 'Total',
      sublabels: {}
    }

    PageSize = Struct.new(:name, :width, :height)

    PAGE_SIZES = {
      letter: PageSize.new('LETTER', 612.00, 792.00),
      a4:     PageSize.new('A4', 595.28, 841.89),
    }

    def self.labels
      @@labels ||= DEFAULT_LABELS
    end

    def self.labels=(labels)
      @@labels = DEFAULT_LABELS.merge(labels)
    end

    def initialize(
      document: Document.new,
      labels: {},
      font: nil,
      bold_font: nil,
      stamp: nil,
      logo: nil,
      background: nil,
      page_size: :letter
    )
      @document  = document
      @labels    = merge_custom_labels(labels)
      @font      = font
      @bold_font = bold_font
      @stamp     = stamp
      @logo      = logo
      @page_size = page_size ? PAGE_SIZES[page_size.to_sym] : PAGE_SIZES[:letter]
      @pdf       = Prawn::Document.new(background: background, page_size: @page_size.name)

      raise InvalidInput, 'document is not a type of InvoicePrinter::Document' \
        unless @document.is_a?(InvoicePrinter::Document)

      if used? @logo
        if File.exist?(@logo)
          @logo = logo
        else
          raise LogoFileNotFound, "Logotype file not found at #{@logo}"
        end
      end

      if used? @stamp
        if File.exist?(@stamp)
          @stamp = stamp
        else
          raise StampFileNotFound, "Stamp file not found at #{@stamp}"
        end
      end

      if used?(@font) && used?(@bold_font)
        use_font(@font, @bold_font)
      elsif used?(@font)
        use_font(@font, @font)
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

    def use_font(font, bold_font)
      if File.exist?(font) && File.exist?(bold_font)
        set_font_from_path(font, bold_font)
      else
        set_builtin_font(font)
      end
    end

    def set_builtin_font(font)
      require 'invoice_printer/fonts'

      @pdf.font_families.update(
        "#{font}" => InvoicePrinter::Fonts.paths_for(font)
      )
      @pdf.font(font)

    rescue StandardError
      raise FontFileNotFound, "Font file not found for #{font}"
    end

    # Add font family in Prawn for a given +font+ file
    def set_font_from_path(font, bold_font)
      font_name = Pathname.new(font).basename
      @pdf.font_families.update(
        "#{font_name}" => {
          normal: font,
          italic: font,
          bold: bold_font,
          bold_italic: bold_font
        }
      )
      @pdf.font(font_name)
    end

    # Build the PDF version of the document (@pdf)
    def build_pdf
      @push_down = 0
      @push_items_table = 0
      @pdf.fill_color '000000'
      @pdf.stroke_color 'aaaaaa'
      build_header
      build_provider_box
      build_purchaser_box
      build_payment_method_box
      build_info_box
      build_description
      build_items
      build_total
      build_stamp
      build_logo
      build_note
      build_footer
    end

    # Build the document name and number at the top:
    #
    #   NAME                      NO. 901905374583579
    #   Sublabel name
    def build_header
      @pdf.text_box(
        @labels[:name],
        size: 20,
        align: :left,
        at: [0, y(720) - @push_down],
        width: x(300),
      )

      if used? @labels[:sublabels][:name]
        @pdf.text_box(
          @labels[:sublabels][:name],
          size: 12,
          at: [0, y(720) - @push_down - 22],
          width: x(300),
          align: :left
        )
      end

      @pdf.text_box(
        @document.number,
        size: 20,
        at: [x(240), y(720) - @push_down],
        width: x(300),
        align: :right
      )

      @pdf.move_down(250)

      if used? @labels[:sublabels][:name]
        @pdf.move_down(12)
      end
    end

    # Build the following provider box:
    #
    #    ------------------------------------------
    #   | Provider       Optional provider sublabel|
    #   | PROVIDER co.                             |
    #   | 5th Street                               |
    #   | 747 27    City                           |
    #   |           Part of the city               |
    #   |                                          |
    #   | Identification number: Number            |
    #   | Identification number: Number 2          |
    #    ------------------------------------------
    #
    def build_provider_box
      @pdf.text_box(
        @document.provider_name,
        size: 15,
        at: [10, y(640) - @push_down],
        width: x(220)
      )
      @pdf.text_box(
        @labels[:provider],
        size: 11,
        at: [10, y(660) - @push_down],
        width: x(240)
      )
      if used? @labels[:sublabels][:provider]
        @pdf.text_box(
          @labels[:sublabels][:provider],
          size: 10,
          at: [10, y(660) - @push_down],
          width: x(246),
          align: :right
        )
      end
      # Render provider_lines if present
      if !@document.provider_lines.empty?
        @pdf.text_box(
          @document.provider_lines,
          size: 10,
          at: [x(10), y(618) - @push_down],
          width: x(246),
          height: y(68),
          leading: 3,
        )
      end
      unless @document.provider_tax_id.empty?
        @pdf.text_box(
          "#{@labels[:tax_id]}:    #{@document.provider_tax_id}",
          size: 10,
          at: [10, y(550) - @push_down],
          width: x(240)
        )
      end
      unless @document.provider_tax_id2.empty?
        @pdf.text_box(
          "#{@labels[:tax_id2]}:    #{@document.provider_tax_id2}",
          size: 10,
          at: [10, y(535) - @push_down],
          width: x(240)
        )
      end
      @pdf.stroke_rounded_rectangle([0, y(670) - @push_down], x(266), y(150), 6)
    end

    # Build the following purchaser box:
    #
    #    -------------------------------------------
    #   | Purchaser      Optinal purchaser sublabel|
    #   | PURCHASER co.                            |
    #   | 5th Street                               |
    #   | 747 27    City                           |
    #   |           Part of the city               |
    #   |                                          |
    #   | Identification number: Number            |
    #   | Identification number: Number 2          |
    #    ------------------------------------------
    #
    def build_purchaser_box
      @pdf.text_box(
        @document.purchaser_name,
        size: 15,
        at: [x(284), y(640) - @push_down],
        width: x(240)
      )
      @pdf.text_box(
        @labels[:purchaser],
        size: 11,
        at: [x(284), y(660) - @push_down],
        width: x(240)
      )

      if used? @labels[:sublabels][:purchaser]
        @pdf.text_box(
          @labels[:sublabels][:purchaser],
          size: 10,
          at: [10, y(660) - @push_down],
          width: x(520),
          align: :right
        )
      end
      # Render purchaser_lines if present
      if !@document.purchaser_lines.empty?
        @pdf.text_box(
          @document.purchaser_lines,
          size: 10,
          at: [x(284), y(618) - @push_down],
          width: x(246),
          height: y(68),
          leading: 3,
        )
      end
      unless @document.purchaser_tax_id.empty?
        @pdf.text_box(
          "#{@labels[:tax_id]}:    #{@document.purchaser_tax_id}",
          size: 10,
          at: [x(284), y(550) - @push_down],
          width: x(240)
        )
      end
      unless @document.purchaser_tax_id2.empty?
        @pdf.text_box(
          "#{@labels[:tax_id2]}:    #{@document.purchaser_tax_id2}",
          size: 10,
          at: [x(284), y(535) - @push_down],
          width: x(240)
        )
      end
      @pdf.stroke_rounded_rectangle([x(274), y(670) - @push_down], x(266), y(150), 6)
    end

    # Build the following payment box:
    #
    #    -----------------------------------------
    #   | Payment on the following bank account:  |
    #   | Number:                       3920392032|
    #   | Optional number sublabel                |
    #   | SWIFT:                                xy|
    #   | Optional SWIFT sublabel                 |
    #   | IBAN:                                 xy|
    #   | Optional IBAN sublabel                  |
    #    -----------------------------------------
    #
    # If the bank account number is not provided include a note about payment
    # in cash.
    def build_payment_method_box
      @push_down -= 3

      unless letter?
        @push_items_table += 18
      end

      # Match the height of next box if needed
      min_height = 60
      if used?(@document.issue_date) || used?(@document.due_date)
        min_height = (used?(@document.issue_date) && used?(@document.due_date)) ? 75 : 60
      end
      @payment_box_height = min_height

      if big_info_box?
        @payment_box_height = 110
      end

      if @document.bank_account_number.empty?
        @pdf.text_box(
          @labels[:payment],
          size: 10,
          at: [10, y(498) - @push_down],
          width: x(234)
        )
        @pdf.text_box(
          @labels[:payment_in_cash],
          size: 10,
          at: [10, y(483) - @push_down],
          width: x(234)
        )

        @pdf.stroke_rounded_rectangle([0, y(508) - @push_down], x(266), @payment_box_height, 6)
      else
        @payment_box_height = 60
        @push_iban = 0
        sublabel_change = 0
        @pdf.text_box(
          @labels[:payment_by_transfer],
          size: 10,
          at: [10, y(498) - @push_down],
          width: x(234)
        )
        @pdf.text_box(
          "#{@labels[:account_number]}",
          size: 11,
          at: [10, y(483) - @push_down],
          width: x(134)
        )
        @pdf.text_box(
          @document.bank_account_number,
          size: 13,
          at: [21, y(483) - @push_down],
          width: x(234),
          align: :right
        )
        if used? @labels[:sublabels][:account_number]
          @pdf.text_box(
            "#{@labels[:sublabels][:account_number]}",
            size: 10,
            at: [10, y(468) - @push_down],
            width: x(334)
          )
        else
          @payment_box_height -= 10
          sublabel_change -= 10
        end
        unless @document.account_swift.empty?
          @pdf.text_box(
            "#{@labels[:swift]}",
            size: 11,
            at: [10, y(453) - @push_down - sublabel_change],
            width: x(134)
          )
          @pdf.text_box(
            @document.account_swift,
            size: 13,
            at: [21, y(453) -  @push_down - sublabel_change],
            width: x(234),
            align: :right
          )

          if used? @labels[:sublabels][:swift]
            @pdf.text_box(
              "#{@labels[:sublabels][:swift]}",
              size: 10,
              at: [10, y(438) - @push_down - sublabel_change],
              width: x(334)
            )
            @push_items_table += 10
          else
            @payment_box_height -= 10
            sublabel_change -= 10
          end

          @payment_box_height += 30
          @push_iban = 30
          @push_items_table += 18
        end
        unless @document.account_iban.empty?
          @pdf.text_box(
            "#{@labels[:iban]}",
            size: 11,
            at: [10, y(453) - @push_iban - @push_down - sublabel_change],
            width: x(134)
          )
          @pdf.text_box(
            @document.account_iban,
            size: 13,
            at: [21, y(453) - @push_iban - @push_down - sublabel_change],
            width: x(234),
            align: :right
          )

          if used? @labels[:sublabels][:iban]
            @pdf.text_box(
              "#{@labels[:sublabels][:iban]}",
              size: 10,
              at: [10, y(438) - @push_iban - @push_down - sublabel_change],
              width: x(334)
            )
            @push_items_table += 10
          else
            @payment_box_height -= 10
          end

          @payment_box_height += 30
          @push_items_table += 18
        end

        if min_height > @payment_box_height
          @payment_box_height = min_height
          @push_items_table += 25
        end

        if !@document.account_swift.empty? && !@document.account_iban.empty?
          @push_items_table += 2
        end

        @pdf.stroke_rounded_rectangle([0, y(508) - @push_down], x(266), @payment_box_height, 6)
      end
    end

    # Build the following info box:
    #
    #    --------------------------------
    #   | Issue date:          03/03/2016|
    #   | Issue date sublabel            |
    #   | Due date:            03/03/2016|
    #   | Due date sublabel              |
    #   | Variable symbol:     VS12345678|
    #   | Variable symbol sublabel       |
    #    --------------------------------
    #
    def build_info_box
      issue_date_present = !@document.issue_date.empty?

      if issue_date_present
        @pdf.text_box(
          @labels[:issue_date],
          size: 11,
          at: [x(284), y(498) - @push_down],
          width: x(240)
        )
        @pdf.text_box(
          @document.issue_date,
          size: 13,
          at: [x(384), y(498) - @push_down],
          width: x(146),
          align: :right
        )

        if used? @labels[:sublabels][:issue_date]
          position = issue_date_present ? 483 : 498

          @pdf.text_box(
            @labels[:sublabels][:issue_date],
            size: 10,
            at: [x(284), y(position) - @push_down],
            width: x(240)
          )
        end
      end

      due_date_present = !@document.due_date.empty?

      if due_date_present
        position = issue_date_present ? 478 : 493
        position -= 10 if used? @labels[:sublabels][:issue_date]

        @pdf.text_box(
          @labels[:due_date],
          size: 11,
          at: [x(284), y(position) - @push_down],
          width: x(240)
        )
        @pdf.text_box(
          @document.due_date,
          size: 13,
          at: [x(384), y(position) - @push_down],
          width: x(146),
          align: :right
        )

        if used? @labels[:sublabels][:due_date]
          position = issue_date_present ? 463 : 478
          position -= 10 if used? @labels[:sublabels][:issue_date]

          @pdf.text_box(
            @labels[:sublabels][:due_date],
            size: 10,
            at: [x(284), y(position) - @push_down],
            width: x(240)
          )
        end
      end

      variable_symbol_present = !@document.variable_symbol.empty?

      if variable_symbol_present
        position = (issue_date_present || due_date_present) ? 483 : 498
        position = issue_date_present && due_date_present ? 458 : 463
        position -= 10 if used? @labels[:sublabels][:issue_date]
        position -= 10 if used? @labels[:sublabels][:due_date]

        @pdf.text_box(
          @labels[:variable_symbol],
          size: 11,
          at: [x(284), y(position) - @push_down],
          width: x(240)
        )
        @pdf.text_box(
          @document.variable_symbol,
          size: 13,
          at: [x(384), y(position) - @push_down],
          width: x(146),
          align: :right
        )

        if used? @labels[:sublabels][:variable_symbol]
          position = issue_date_present ? 443 : 458
          position -= 10 if used? @labels[:sublabels][:issue_date]
          position -= 10 if used? @labels[:sublabels][:due_date]

          @pdf.text_box(
            @labels[:sublabels][:variable_symbol],
            size: 10,
            at: [x(284), y(position) - @push_down],
            width: x(240)
          )
        end
      end

      if issue_date_present || due_date_present || variable_symbol_present
        big_box = (issue_date_present && due_date_present && variable_symbol_present && info_box_sublabels_used?)
        height = (issue_date_present && due_date_present) ? 75 : 60
        height = big_box ? 110 : height
        height = @payment_box_height if @payment_box_height > height

        @pdf.stroke_rounded_rectangle([x(274), y(508) - @push_down], x(266), height, 6)
        @push_items_table += 23 if @push_items_table <= 18
        @push_items_table += 24 if big_box

        #@push_items_table += 30
      end
    end

    def big_info_box?
      !@document.issue_date.empty? &&
      !@document.due_date.empty? &&
      !@document.variable_symbol.empty? &&
      info_box_sublabels_used?
    end

    def info_box_sublabels_used?
      used?(@labels[:sublabels][:issue_date]) ||
      used?(@labels[:sublabels][:due_date]) ||
      used?(@labels[:sublabels][:variable_symbol])
    end

    def build_description
      unless @document.description.empty?
        @pdf.text_box(
          @document.description,
          size: 11,
          align: :left,
          at: [0, y(450) - @push_down - 26]
        )
        @push_items_table += description_height + 8
      end
    end

     def description_height
      @description_height ||= begin
        num_of_lines = @document.description.lines.count
        (num_of_lines * 13)
      end
    end

    # Build the following table for document items:
    #
    #   =================================================================
    #   |Item |  Quantity|  Unit|  Price per item|  Tax|  Total per item|
    #   |-----|----------|------|----------------|-----|----------------|
    #   |x    |         2|    hr|              $2|   $1|              $4|
    #   =================================================================
    #
    # variable (2nd position), tax2 and tax3 (after tax) fields can be added
    # as well if necessary. variable does not come with any default label.
    # If a specific column miss data, it's omittted.
    #
    # Using sublabels one can change the table to look as:
    #
    #   =================================================================
    #   |Item |  Quantity|  Unit|  Price per item|  Tax|  Total per item|
    #   |it.  |      nom.|   un.|            ppi.|   t.|            tpi.|
    #   |-----|----------|------|----------------|-----|----------------|
    #   |x    |         2|    hr|              $2|   $1|              $4|
    #   =================================================================
    def build_items
      @pdf.move_down(23 + @push_items_table + @push_down)

      items_params = determine_items_structure
      items = build_items_data(items_params)
      headers = build_items_header(items_params)
      data = items.prepend(headers)

      options = {
        header: true,
        row_colors: [nil, 'ededed'],
        width: x(540, 2),
        cell_style: {
          borders: []
        }
      }

      unless items.empty?
        @pdf.font_size(10) do
          @pdf.table(data, options) do
            row(0).background_color = 'e3e3e3'
            row(0).border_color = 'aaaaaa'
            row(0).borders = [:bottom]
            row(items.size - 1).borders = [:bottom]
            row(items.size - 1).border_color = 'd9d9d9'
          end
        end
      end
    end

    # Determine sections of the items table to show based on provided data
    def determine_items_structure
      items_params = {}
      @document.items.each do |item|
        items_params[:names] = true unless item.name.empty?
        items_params[:variables] = true unless item.variable.empty?
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
        line << { content: name_cell(item), borders: [:bottom] } if items_params[:names]
        #line << { content: item.name, borders: [:bottom], align: :left } if items_params[:names]
        line << { content: item.variable, align: :right } if items_params[:variables]
        line << { content: item.quantity, align: :right } if items_params[:quantities]
        line << { content: item.unit, align: :right } if items_params[:units]
        line << { content: item.price, align: :right } if items_params[:prices]
        line << { content: item.tax, align: :right } if items_params[:taxes]
        line << { content: item.tax2, align: :right } if items_params[:taxes2]
        line << { content: item.tax3, align: :right } if items_params[:taxes3]
        line << { content: item.amount, align: :right } if items_params[:amounts]
        line
      end
    end

    # Display item's name and breakdown if present
    def name_cell(item)
      data = if used?(item.breakdown)
        data = [
          [{ content: item.name, padding: [5, 0, 0, 5] }],
          [{ content: item.breakdown, size: 8, padding: [2, 0, 5, 5] }]
        ]

        options = {
          cell_style: {
            borders: []
          },
          position: :left
        }

        @pdf.make_table(data, options)
      else
        item.name
      end
    end

    # Include only relevant headers
    def build_items_header(items_params)
      headers = []
      headers << { content: label_with_sublabel(:item), align: :left } if items_params[:names]
      headers << { content: label_with_sublabel(:variable), align: :right } if items_params[:variables]
      headers << { content: label_with_sublabel(:quantity), align: :right } if items_params[:quantities]
      headers << { content: label_with_sublabel(:unit), align: :right } if items_params[:units]
      headers << { content: label_with_sublabel(:price_per_item), align: :right } if items_params[:prices]
      headers << { content: label_with_sublabel(:tax), align: :right } if items_params[:taxes]
      headers << { content: label_with_sublabel(:tax2), align: :right } if items_params[:taxes2]
      headers << { content: label_with_sublabel(:tax3), align: :right } if items_params[:taxes3]
      headers << { content: label_with_sublabel(:amount), align: :right } if items_params[:amounts]
      headers
    end

    # This merge a label with its sublabel on a new line
    def label_with_sublabel(symbol)
      value = @labels[symbol]
      if used? @labels[:sublabels][symbol]
        value += "\n#{@labels[:sublabels][symbol]}"
      end
      value
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

      items << [
        { content: "#{@labels[:subtotal]}:#{build_sublabel_for_total_table(:subtotal)}", align: :left },
        { content: @document.subtotal, align: :right }
      ] unless @document.subtotal.empty?

      items << [
        { content: "#{@labels[:tax]}:#{build_sublabel_for_total_table(:tax)}", align: :left },
        { content:  @document.tax, align: :right }
      ] unless @document.tax.empty?

      items << [
        { content: "#{@labels[:tax2]}:#{build_sublabel_for_total_table(:tax2)}", align: :left },
        { content:  @document.tax2, align: :right }
      ] unless @document.tax2.empty?

      items << [
        { content: "#{@labels[:tax3]}:#{build_sublabel_for_total_table(:tax3)}", align: :left },
        { content:  @document.tax3, align: :right }
      ] unless @document.tax3.empty?

      items << [
        { content: "\n#{@labels[:total]}:#{build_sublabel_for_total_table(:total)}", align: :left, font_style: :bold, size: 16 },
        { content:  "\n#{@document.total}", align: :right, font_style: :bold, size: 16 }
      ] unless @document.total.empty?

      options = {
        cell_style: {
          borders: []
        },
        position: :right
      }

      @pdf.table(items, options) unless items.empty?
    end

    # Return sublabel on a new line or empty string
    def build_sublabel_for_total_table(sublabel)
      if used? @labels[:sublabels][sublabel]
        "\n#{@labels[:sublabels][sublabel]}:"
      else
        ''
      end
    end

    # Insert a logotype at the left bottom of the document
    #
    # If a note is present, position it on top of it.
    def build_logo
      if @logo && !@logo.empty?
        bottom = @document.note.empty? ? 75 : (75 + note_height)
        @pdf.image(@logo, at: [0, bottom], fit: [x(200), y(50)])
      end
    end

    # Insert a stamp (with signature) after the total table
    def build_stamp
      if @stamp && !@stamp.empty?
        @pdf.move_down(15)
        @pdf.image(@stamp, position: :right, fit: [x(200), y(40)])
      end
    end

    # Note at the end
    def build_note
      @pdf.text_box(
        "#{@document.note}",
        size: 10,
        at: [0, note_height],
        width: x(450),
        align: :left
      )
    end

    def note_height
      @note_height ||= begin
        num_of_lines = @document.note.lines.count
        (num_of_lines * 11)
      end
    end

    # Include page numbers if we got more than one page
    def build_footer
      @pdf.number_pages(
        '<page> / <total>',
        start_count_at: 1,
        at: [@pdf.bounds.right - 50, 0],
        align: :right,
        size: 12
      ) unless @pdf.page_count == 1
    end

    def used?(element)
      element && !element.empty?
    end

    def letter?
      @page_size.name == 'LETTER'
    end

    # Return correct x/width relative to page size
    def x(value, adjust = 1)
      return value if letter?

      width_ratio = value / PAGE_SIZES[:letter].width
      (width_ratio * @page_size.width) - adjust
    end

    # Return correct y/height relative to page size
    def y(value)
      return value if letter?

      width_ratio = value / PAGE_SIZES[:letter].height
      width_ratio * @page_size.height
    end

    def merge_custom_labels(labels = {})
      custom_labels = if labels
                        hash_keys_to_symbols(labels)
                      else
                        {}
                      end

      PDFDocument.labels.merge(custom_labels)
    end

    def hash_keys_to_symbols(value)
      return value unless value.is_a? Hash

      value.inject({}) do |memo, (k, v)|
        memo[k.to_sym] = hash_keys_to_symbols(v)
        memo
      end
    end
  end
end
