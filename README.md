Task:
"There is a Binance type crypto-exchange, the user wants to transfer us historical data about his trading activity in read-only mode. We need to collect data through the API and output it to the console.
Requirements:
- mysql database
- table credentials (key, secret), create by migration
- VCR-tests for receiving data from Binance. If the API key is incorrect, write an error to the log.
- go through all the credentials table. For everyone pull data
- the result should be a hash
{credential_id: 123, trades: [{date: 2018-10-11, type: 'BUY / SELL', price: 34, quantity: 10}], balances: []}"


ruby main.rb -- runs the programme


rspec spec/api_requests_spec.rb -- runs the specs which test how api works:
- ping call (public) just for checking connection with Binance API (there is no need API key and secret or any params)
- three account endpoints (require some kind of params and signature) - included general tests on status 200 and class of returned object and tests for fields that are needed for response_hash
