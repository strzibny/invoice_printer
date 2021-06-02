require 'base64'
require 'roda'
require 'invoice_printer'

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

      document   = params[:document]
      labels     = params[:labels]
      font       = params[:font]
      bold_font  = params[:bold_font]
      stamp      = params[:stamp]
      logo       = params[:logo]
      background = params[:background]
      page_size  = params[:page_size]
    else
      response.status = 400
      response.write(
        {
          result: 'error',
          error: 'No JSON. Did you set Content-Type to application/json?'
        }.to_json
      )
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
          document:   document,
          labels:     labels,
          font:       font,
          bold_font:  bold_font,
          stamp:      stamp,
          logo:       logo,
          background: background,
          page_size:  page_size,
          file_name:  filename
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
          document:   document,
          labels:     labels,
          font:       font,
          bold_font:  bold_font,
          stamp:      stamp,
          logo:       logo,
          background: background,
          page_size:  page_size
        )

        { result: 'ok', data: Base64.strict_encode64(stream) }.to_json
      rescue => e
        response.status = 400
        response.write({ result: 'error', error: e.message }.to_json)
        r.halt
      end
    end
  end
end
