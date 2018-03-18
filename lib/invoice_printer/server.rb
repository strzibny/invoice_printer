require 'base64'
require 'roda'
require 'invoice_printer'

# curl -H "Content-Type: text/html; charset=UTF-8" --data 'document={"number":"č. 198900000001","provider_name":"Petr Nový","provider_tax_id":"56565656","provider_tax_id2":"","provider_street":"Rolnická","provider_street_number":"1","provider_postcode":"747 05","provider_city":"Opava","provider_city_part":"Kateřinky","provider_extra_address_line":"","purchaser_name":"Adam Černý","purchaser_tax_id":"","purchaser_tax_id2":"","purchaser_street":"Ostravská","purchaser_street_number":"1","purchaser_postcode":"747 70","purchaser_city":"Opava","purchaser_city_part":"","purchaser_extra_address_line":"","issue_date":"05/03/2016","due_date":"19/03/2016","subtotal":"Kč 10.000","tax":"Kč 2.100","tax2":"","tax3":"","total":"Kč 12.100,-","bank_account_number":"156546546465","account_iban":"IBAN464545645","account_swift":"SWIFT5456","items":[{"name":"Konzultace","quantity":"2","unit":"hod","price":"Kč 500","tax":"","tax2":"","tax3":"","amount":"Kč 1.000"},{"name":"Programování","quantity":"10","unit":"hod","price":"Kč 900","tax":"","tax2":"","tax3":"","amount":"Kč 9.000"}],"note":"Osoba je zapsána v živnostenském rejstříku."}' -X POST http://0.0.0.0:9292/render
class InvoicePrinter::Server < Roda
  route do |r|
    response['Content-Type'] = 'application/json'

    # Assign params
    if r.content_type == 'application/json'
      begin
        params = JSON.parse(r.body.read, symbolize_names: true)
      rescue => e
        response.status = 400
        response.write({ result: 'error', error: 'Invalid JSON.' }.to_json)
        r.halt
      end

      labels   = params[:labels]
      document = params[:document]
      stamp    = params[:stamp]
      logo     = params[:logo]
      font     = params[:font]
    else
      response.status = 400
      response.write({ result: 'error', error: 'No JSON. Did you set Content-Type to application/json?' }.to_json)
      r.halt
    end

    # Initialize InvoicePrinter::Document from given JSON
    begin
      document[:items] ||= []
      items = document[:items].map { |item| InvoicePrinter::Document::Item.new(**item) }
      document[:items] = items

      document = InvoicePrinter::Document.new(**document)
    rescue => e
      response.status = 400
      response.write({ result: 'error', error: 'Invalid JSON document.' }.to_json)
      r.halt
    end

    # POST /print
    r.post 'print' do
      filename = params[:filename] || 'document.pdf'

      begin
        InvoicePrinter.print(
          document:  document,
          font:      font,
          stamp:     stamp,
          logo:      logo,
          file_name: filename
        )

        { result: 'ok', path: filename }.to_json
      rescue => e
        response.status = 400
        response.write({ result: 'error', error: e.message }.to_json)
        r.halt
      end
    end

    # POST /render
    r.post 'render' do
      begin
        stream = InvoicePrinter.render(
          document: document,
          font:     font,
          stamp:    stamp,
          logo:     logo
        )

        { result: 'ok', data: Base64.encode64(stream) }.to_json
      rescue => e
        response.status = 400
        response.write({ result: 'error', error: e.message }.to_json)
        r.halt
      end
    end
  end
end