require 'faraday'
require 'json'

class HistoricalTrades

  def initialize(client, symbol_string, limit=nil, fromId=nil)
    @client = client
    @symbol = symbol_string
    @limit = limit
    @fromId = fromId
  end

  def call_to_api
    @client.connection.get do |request|
      request.url 'api/v1/historicalTrades'
      request.headers["X-MBX-APIKEY"] = @client.api_key
      request.params['symbol'] = @symbol
      request.params['limit'] = @limit if @limit
      request.params['fromId'] = @fromId if @fromId
    end
  end

  def raw_response
    response = call_to_api
    response_body = JSON.parse(response.body)
    Application.log(:error, "401 Unauthorized: #{response_body}") if response.status == 401
    response_body
  end

  def response_hash
    hash = { credential_id: @client.credential_id, trades: [], positions:[] }
    raw_response.each { |trade| hash[:trades] << trade_info(trade) }
    hash
  end

  private

  def trade_info(trade)
    t = {}

    t[:date] = time(trade['time'])
    t[:symbol] = @symbol
    t[:type] = trade['isBuyerMaker'] ? 'Maker' : 'Taker'
    t[:price] = trade['price']
    t[:quantity] = trade['qty']

    t
  end

  def time(milisec)
    Time.at(milisec/1000).strftime("%F %T")
  end
end
