// Example: Create a PDF invoice and save it to a file called invoice_from_node.pdf
//
// This example requires InvoicePrinter Server to be running.
//
// You can run the server as:
//   $ invoice_printer_server
//
// And run this example as:
//   $ node node.js

const invoice = {
  "number": "NO. 198900000001",
  "provider_name": "John White",
  "provider_tax_id": "",
  "provider_tax_id2": "",
  "provider_street": "5th Avenue",
  "provider_street_number": "1",
  "provider_postcode": "747 05",
  "provider_city": "NYC",
  "provider_city_part": "",
  "provider_extra_address_line": "",
  "purchaser_name": "Will Black",
  "purchaser_tax_id": "",
  "purchaser_tax_id2": "",
  "purchaser_street": "7th Avenue",
  "purchaser_street_number": "1",
  "purchaser_postcode": "747 70",
  "purchaser_city": "NYC",
  "purchaser_city_part": "",
  "purchaser_extra_address_line": "",
  "issue_date": "05/03/2016",
  "due_date": "19/03/2016",
  "subtotal": "$ 1,000",
  "tax": "$ 100",
  "tax2": "",
  "tax3": "",
  "total": "$ 1,100",
  "bank_account_number": "156546546465",
  "account_iban": "",
  "account_swift": "",
  "items": [
    {
      "name": "Programming",
      "quantity": "10",
      "unit": "hr",
      "price": "$ 60",
      "tax": "$ 60",
      "tax2": "",
      "tax3": "",
      "amount": "$ 600"
    },
    {
      "name": "Consulting",
      "quantity": "10",
      "unit": "hr",
      "price": "$ 30",
      "tax": "$ 30",
      "tax2": "",
      "tax3": "",
      "amount": "$ 300"
    },
    {
      "name": "Support",
      "quantity": "20",
      "unit": "hr",
      "price": "$ 15",
      "tax": "$ 30",
      "tax2": "",
      "tax3": "",
      "amount": "$ 330"
    }
  ],
  "note": "This is a note at the end."
}

const http = require('http');
const fs = require('fs');

// Prepare the JSON in the expected format
const postData = JSON.stringify({
  "document" : invoice
});

// Prepare POST options such as correct headers
const postOptions = {
    host: 'localhost',
    port: '9393',
    path: '/render',
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    }
};

const postRequest = http.request(postOptions, (resp) => {
  let data = '';

  resp.on('data', (chunk) => {
    data += chunk;
  });

  // Save the PDF if everything went okay
  resp.on('end', () => {
    response = JSON.parse(data);

    if (response["data"]) {
      const pdf = Buffer.from(response["data"], 'base64');

      fs.writeFile("invoice_from_node.pdf", pdf, function(err) {
        if(err) {
          return console.log(err);
        }

        console.log("The file was saved!");
      });
    } else {
      console.log("Error: " + response["error"])
    }
  });
}).on("error", (err) => {
  console.log("Error: " + err.message);
});

postRequest.write(postData);
postRequest.end();
