module InvoicePrinter
  # Invoice and receipt representation
  #
  # Example:
  #
  #   invoice = InvoicePrinter::Document.new(
  #     number: '198900000001',
  #     provider_name: 'Business s.r.o.',
  #     provider_tax_id: '56565656',
  #     provider_tax_id2: '465454',
  #     provider_lines: "Rolnicka 1\n747 05 Opava",
  #     purchaser_name: 'Adam',
  #     purchaser_tax_id: '',
  #     purchaser_tax_id2: '',
  #     purchaser_lines: "Ostravska 2\n747 05 Opava",
  #     issue_date: '19/03/3939',
  #     due_date: '19/03/3939',
  #     variable_symbol: '198900000001',
  #     subtotal: '$ 150',
  #     tax: '$ 50',
  #     total: '$ 200',
  #     bank_account_number: '156546546465',
  #     account_iban: 'IBAN464545645',
  #     account_swift: 'SWIFT5456',
  #     description: "We are invoicing you the following items:",
  #     items: [
  #       InvoicePrinter::Document::Item.new,
  #       InvoicePrinter::Document::Item.new
  #     ],
  #     note: 'A note at the end.'
  #   )
  #
  # +amount should equal the sum of all item's +amount+,
  # but this is not enforced.
  class Document
    class InvalidInput < StandardError; end

    attr_reader :number,
                # Provider fields
                :provider_name,
                :provider_tax_id,
                :provider_tax_id2,
                :provider_lines,
                # Purchaser fields
                :purchaser_name,
                :purchaser_tax_id,
                :purchaser_tax_id2,
                :purchaser_lines,
                :issue_date,
                :due_date,
                :variable_symbol,
                # Account details
                :subtotal,
                :tax,
                :tax2,
                :tax3,
                :total,
                :bank_account_number,
                :account_iban,
                :account_swift,
                :description,
                # Collection of InvoicePrinter::Invoice::Items
                :items,
                :note

    class << self
      def from_json(json)
        new(
          number: json['number'],
          provider_name: json['provider_name'],
          provider_tax_id: json['provider_tax_id'],
          provider_tax_id2: json['provider_tax_id2'],
          provider_lines: json['provider_lines'],
          purchaser_name: json['purchaser_name'],
          purchaser_tax_id: json['purchaser_tax_id'],
          purchaser_tax_id2: json['purchaser_tax_id2'],
          purchaser_lines: json['purchaser_lines'],
          issue_date: json['issue_date'],
          due_date: json['due_date'],
          variable_symbol: json['variable_symbol'],
          subtotal: json['subtotal'],
          tax: json['tax'],
          tax2: json['tax2'],
          tax3: json['tax3'],
          total: json['total'],
          bank_account_number: json['bank_account_number'],
          account_iban: json['account_iban'],
          account_swift: json['account_swift'],
          description: json['description'],
          note: json['note'],

          items: (json['items'] || []).map { |item_json| Item.from_json(item_json) }
        )
      end
    end

    def initialize(number: nil,
                   provider_name: nil,
                   provider_tax_id: nil,
                   provider_tax_id2: nil,
                   provider_lines: nil,
                   purchaser_name: nil,
                   purchaser_tax_id: nil,
                   purchaser_tax_id2: nil,
                   purchaser_lines: nil,
                   issue_date: nil,
                   due_date: nil,
                   variable_symbol: nil,
                   subtotal: nil,
                   tax: nil,
                   tax2: nil,
                   tax3: nil,
                   total: nil,
                   bank_account_number: nil,
                   account_iban: nil,
                   account_swift:  nil,
                   description: nil,
                   items: nil,
                   note: nil)

      @number = String(number)
      @provider_name = String(provider_name)
      @provider_tax_id = String(provider_tax_id)
      @provider_tax_id2 = String(provider_tax_id2)
      @provider_lines = String(provider_lines)
      @purchaser_name = String(purchaser_name)
      @purchaser_tax_id = String(purchaser_tax_id)
      @purchaser_tax_id2 = String(purchaser_tax_id2)
      @purchaser_lines = String(purchaser_lines)
      @issue_date = String(issue_date)
      @due_date = String(due_date)
      @variable_symbol = String(variable_symbol)
      @subtotal = String(subtotal)
      @tax = String(tax)
      @tax2 = String(tax2)
      @tax3 = String(tax3)
      @total = String(total)
      @bank_account_number = String(bank_account_number)
      @account_iban = String(account_iban)
      @account_swift = String(account_swift)
      @description = String(description)
      @items = items
      @note = String(note)

      raise InvalidInput, 'items are not only a type of InvoicePrinter::Document::Item' \
        unless @items.select{ |i| !i.is_a?(InvoicePrinter::Document::Item) }.empty?
    end

    def to_h
      {
        'number': @number,
        'provider_name': @provider_name,
        'provider_tax_id': @provider_tax_id,
        'provider_tax_id2': @provider_tax_id2,
        'provider_lines': @provider_lines,
        'purchaser_name': @purchaser_name,
        'purchaser_tax_id': @purchaser_tax_id,
        'purchaser_tax_id2': @purchaser_tax_id2,
        'purchaser_lines': @purchaser_lines,
        'issue_date': @issue_date,
        'due_date': @due_date,
        'variable_symbol': @variable_symbol,
        'subtotal': @subtotal,
        'tax': @tax,
        'tax2': @tax2,
        'tax3': @tax3,
        'total': @total,
        'bank_account_number': @bank_account_number,
        'account_iban': @account_iban,
        'account_swift': @account_swift,
        'description': @description,
        'items': @items.map(&:to_h),
        'note': @note
      }
    end

    def to_json
      to_h.to_json
    end
  end
end
