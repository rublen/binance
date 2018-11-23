require_relative 'environments/development'
require 'pp'

# Credential.create(api_key: '', api_secret: '')

item = Credential.last
client = BinanceClient.new(item)
pp HistoricalTrades.new(client, 'ETHBTC', 5).response_hash

Application.log(:info, "Hello! #{item}")
