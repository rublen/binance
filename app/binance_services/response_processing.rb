class ResponseProcessing

  def initialize(client)
    @client = client
  end

  def raw_response(api_request)
    response = api_request.call_to_api
    response_body = JSON.parse(response.body)
    Application.log(:error, "401 Unauthorized: #{response_body}") if response.status >= 400
    response_body
  end

  def response_hash
    account_info = raw_response AccountInformation.new(@client, recvWindow: 5000)
    trade_list = raw_response AccauntTradeList.new(@client, 'ETHBTC', limit: 2)
    hash = { credential_id: @client.credential_id, trades: [], positions: account_info[:balances] }
    trade_list.each { |trade| hash[:trades] << trade_info(trade) }
    hash
  end

  private

  def trade_info(trade)
    t = {}

    t[:date] = time(trade['time'])
    t[:symbol] = trade['symbol']
    t[:type] = trade['isBuyer'] ? 'BUY' : 'SELL'
    t[:price] = trade['price']
    t[:quantity] = trade['qty']

    t
  end

  def time(milisec)
    Time.at(milisec/1000).strftime("%F %T")
  end
end
