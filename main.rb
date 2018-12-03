require_relative 'environments/development'
require 'pp'

# Credential.create(api_key: '', api_secret: '')

item = Credential.first
client = BinanceClient.new(item)
processor = ResponseProcessing.new(client)
pp processor.response_hash
# pp processor.raw_response(client.account_information, recvWindow: 5000)
# pp processor.raw_response(client.account_trade_list, symbol: 'ETHBTC', limit: 2)
# pp processor.raw_response(client.all_orders, symbol: 'ETHBTC', limit: 2)
