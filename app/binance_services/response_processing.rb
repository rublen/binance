class ResponseProcessing

  def initialize(client)
    @client = client
  end

  def raw_response(api_request, args = {})
    response = @client.send(api_request, args)
    response_body = JSON.parse(response.body)
    raise response_body if response.status >= 400
    response_body
  rescue Exception => e
    Application.log(:error, "From reuquest: #{api_request}, #{response.status}: #{response_body}")
    puts "ERROR from reuquest: #{api_request}, status #{response.status}, #{e.message}, message: '#{response_body["msg"]}'"
  end

  def response_hash(args = { symbol: 'ETHBTC', limit: 2 })
  # args = { symbol: 'ETHBTC', start_time: nil, end_time: nil, limit: nil, fromId: nil, recvWindow: nil }
    account_info = raw_response(:account_information, recvWindow: args[:recvWindow] || 5000)
    trade_list = raw_response(:account_trade_list, args)
    return unless account_info && trade_list
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

# class Error < StandardError
#   response.status
# end
