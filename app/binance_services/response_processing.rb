class ResponseProcessing

  def initialize(client)
    @client = client
  end

  def raw_response(api_request, *args)
    response = @client.public_send(api_request, *args)
    response_body = JSON.parse(response.body)
    Application.log(:error, "#{response.status}: #{response_body}") if response.status >= 400
    response_body
  end

  def response_hash
    account_info = raw_response(:account_information, recvWindow: 5000)
    trade_list = raw_response(:account_trade_list, 'ETHBTC', limit: 2)
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
