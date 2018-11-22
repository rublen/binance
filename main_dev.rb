require_relative 'environments/development'
require 'pp'

item = Credential.last
# Credential.all.each do |item|
  client = BinanceClient.new(item)
  hystorical_trades = HistoricalTrades.new(client, 'ETHBTC', 5).response_hash

  pp (hystorical_trades)

  Application.log("Hello! #{item}")
# end

# p Credential.all


