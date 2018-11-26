class ResponseProcessing

  def initialize(client)
    @client = client
  end

  def raw_response
    response = call_to_api
    response_body = JSON.parse(response.body)
    Application.log(:error, "401 Unauthorized: #{response_body}") if response.status >= 400
    response_body
  end

  def response_hash
    account_info = AccountInformation.new(@client, recvWindow: 5000)
    hash = { credential_id: @client.credential_id, trades: [], positions: account_info[:balances] }
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
