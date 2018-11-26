require_relative 'environments/development'
require 'pp'

# Credential.create(api_key: '', api_secret: '')

item = Credential.first
client = BinanceClient.new(item)
# pp HistoricalTrades.new(client, 'ETHBTC', 5).response_hash
p '------------------------------'
pp AccauntTradeList.new(client, 'ETHBTC', limit: 2).raw_response
p '------------------------------'
pp AccountInformation.new(client, recvWindow: 5000).raw_response
p '------------------------------'
pp AllOrders.new(client, 'ETHBTC', limit: 2).raw_response

Application.log(:info, "Hello! #{item}")


# echo -n "limit=2&symbol=ETHBTC&timestamp=1542972836855" | openssl dgst -sha256 -hmac "api_secret"
# https://api.binance.com/api/v3/myTrades?limit=2&signature=63793e69f3f5ed44c7e0b6efff430af69501d5b90db34c2125c4f9d3aa55f43c&symbol=ETHBTC&timestamp=1542972836855
