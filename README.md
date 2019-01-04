###Binance API use
- a test task for one company, that I failed at first

####Task:
"There is a Binance type crypto-exchange, the user wants to transfer historical data about his trading activity in read-only mode. We need to collect data through the API and output it to the console.

__Requirements:__
- mysql database
- table :credentials (key, secret) created through migration
- VCR-tests for receiving data from Binance. If the API key is incorrect, write an error to the log.
- go through all the credentials and pull data for each one.
- the result should be a hash like this:
{credential_id: 123, trades: [{date: 2018-10-11, type: 'BUY / SELL', price: 34, quantity: 10}], balances: []}"


__Run the programme__
_ruby main.rb_ -- runs the programme, it has some explanations and some commented code that perhaps may be useful


__Testing__
_rspec spec/api_requests_spec.rb_ -- runs the specs which test how api works:
- ping call (public) just for checking connection with Binance API (there is no need API key and secret or any params)
- three account endpoints (require some kind of params and signature) - included general tests on status 200 and class of returned object and tests for fields that are needed for response_hash

_rspec spec/responce_processing_spec.rb_ -- runs the specs which test ResponseProcessing class:
- method #raw_response should raise an error in case invalid api_key or return response body in other case
- method #response_hash shoud return a hash with appropriate structure (see in requirements)
