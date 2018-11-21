require_relative 'environments/development'
require 'pp'

client = BinanceClient.new(Credential.last)
hystorical_trades = HistoricalTrades.new(client, 'ETHBTC', 5).response_hash

pp (hystorical_trades)

Application.log('Hello!')

# p Credential.all
