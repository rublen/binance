require_relative 'environments/development'
require 'pp'

# To add new credential to DB fill in api_key and api_secret in next line, uncomment it
# execute this file once, remove filled values and commet the line again
# Credential.create(api_key: '', api_secret: '')

items = Credential.all

items.each do |item|
  client = BinanceClient.new(item)
  processor = ResponseProcessing.new(client)
  pp processor.response_hash
end

=begin
  method #response_hash accepts hash as a parameter,
  by default it looks like { symbol: 'ETHBTC', start_time: nil, end_time: nil, limit: 2, fromId: nil, recvWindow: nil }
  but you can pass any other valid value for each key
  for example: processor.response_hash(symbol: 'ETHBTC', limit: 100, recvWindow: 10000)
=end

# client = BinanceClient.new(items[0])
# processor = ResponseProcessing.new(client)

# make ping-request to check the connection, you should receive empty hash
# p client.public_call('/api/v1/ping').body


# pp processor.raw_response(:account_information, recvWindow: 5000)
# pp processor.raw_response(:account_trade_list, symbol: 'ETHBTC', limit: 2)
# pp processor.raw_response(:all_orders, symbol: 'ETHBTC', limit: 2)
