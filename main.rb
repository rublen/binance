require_relative 'environments/development'
require 'pp'

# Credential.create(api_key: '', api_secret: '')

item = Credential.first
client = BinanceClient.new(item)
processor = ResponseProcessing.new(client)
begin
  pp processor.response_hash
  pp processor.raw_response(:account_information, recvWindow: 5000)
  pp processor.raw_response(:account_trade_list, 'ETHBTC', limit: 2)
  pp processor.raw_response(:all_orders, 'ETHBTCL', limit: 2)
rescue Exception => e
  Application.log(:error, e.message)
end



# echo -n "limit=2&symbol=ETHBTC&timestamp=1542972836855" | openssl dgst -sha256 -hmac "api_secret"
# https://api.binance.com/api/v3/myTrades?limit=2&signature=63793e69f3f5ed44c7e0b6efff430af69501d5b90db34c2125c4f9d3aa55f43c&symbol=ETHBTC&timestamp=1542972836855
