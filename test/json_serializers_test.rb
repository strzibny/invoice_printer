require 'test_helper'

class JSONSerializersTest < Minitest::Test
  include InvoicePrinterHelpers

  def test_serialize_item_to_json
    json = InvoicePrinter::Document::Item.new(default_document_item_params).to_json

    assert_equal 'Web consultation', JSON(json)['name']
    assert_equal 'hours', JSON(json)['unit']
  end

  def test_serialize_document_to_json
    json = InvoicePrinter::Document.new(default_document_params).to_json

    assert_equal '198900000001', JSON(json)['number']
    assert_equal 'Web consultation', JSON(json)['items'][0]['name']
  end

  def test_create_document_from_json
    json_params = default_document_params.merge(
      issue_date: '05/03/2016',
      due_date: '14/03/2016',
      items: [{
        name: 'Web consultation',
        quantity: '2',
        unit: 'hours',
        price: '$ 25',
        tax: '$ 1',
        amount: '$ 100'
      }]
    ).to_json
    from_json = InvoicePrinter::Document.from_json(json_params)

    assert_equal '05/03/2016', from_json.issue_date
    assert_equal '14/03/2016', from_json.due_date
    assert_equal InvoicePrinter::Document::Item, from_json.items[0].class
    assert_equal 'Web consultation', from_json.items[0].name
  end
end
