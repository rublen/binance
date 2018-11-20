require 'faraday'

class Binance
  BASE_ENDPOINT = 'https://api.binance.com/'

  attr_reader :connection

  def initialize(credential)
    @api_key = credential.key
    @api_secret = credential.secret
    @connection = Faraday.new(url: BASE_ENDPOINT)
  end

  def hystorical_trades_call(symbol_string, limit=nil, fromId=nil)
    connection.get do |request|
      request.url 'api/v1/historicalTrades'
      request.headers["X-MBX-APIKEY"] = @api_key
      request.params['symbol'] = symbol_string
      request.params['limit'] = limit if limit
      request.params['fromId'] = fromId if fromId
    end
  end

  def public_call(url='/api/v1/ping')
    connection.get(url)
  end
end
