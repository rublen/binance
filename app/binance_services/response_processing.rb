class ResponseProcessing

  def initialize(client)
    @client = client
  end

  def raw_response(api_url, *args)
    response = @client.call(api_url, *args)
    response_body = JSON.parse(response.body)
    Application.log(:error, "#{response.status}: #{response_body}") if response.status >= 400
    response_body
  end

  def response_hash
    account_info = raw_response(@client.account_information, recvWindow: 5000)
    trade_list = raw_response(@client.account_trade_list, symbol: 'ETHBTC', limit: 2)
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
