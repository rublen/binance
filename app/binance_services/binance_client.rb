require 'faraday'

class BinanceClient
  BASE_ENDPOINT = 'https://api.binance.com/'
  ALL_ORDERS_URL = 'api/v3/allOrders'
  ACCAUNT_TRADE_LIST_URL = 'api/v3/myTrades'
  ACCAUNT_INFORMATION_URL = 'api/v3/account'

  def initialize(credential)
    @credential = credential
    @connection = Faraday.new(url: BASE_ENDPOINT)
  end

  def credential_id
    @credential.id
  end

  def account_information(options = {})
  # mandatory parameters - :timestamp; optional - :recvWindow
    params = { timestamp: timestamp, **options }
    call_to_api(ACCAUNT_INFORMATION_URL, params)
  end

  def account_trade_list(symbol, options = {})
  # mandatory - :symbol, :timestamp; optional - :start_time, :end_time, :limit, :fromId, :recvWindow
    params = { symbol: symbol, timestamp: timestamp, **options }
    call_to_api(ACCAUNT_TRADE_LIST_URL, params)
  end

  def all_orders(symbol, options = {})
  # mandatory - :symbol, :timestamp; optional - :start_time, :end_time, :limit, :orderId, :recvWindow
    params = { symbol: symbol, timestamp: timestamp, **options }
    call_to_api(ALL_ORDERS_URL, params)
  end


  private

  def call_to_api(url, params)
    @connection.get do |request|
      request.url url
      request.headers["X-MBX-APIKEY"] = @credential.api_key
      request.params.merge!(params)
      request.params['signature'] = sha256_code(params)
    end
  end

  def timestamp
    (Time.now.to_f*1000).to_i
  end

  def sha256_code(params)
    key = @credential.api_secret
    data = query_string(params)
    OpenSSL::HMAC.hexdigest("SHA256", key, data)
  end

  def query_string(params)
    arr = []
    params.each { |k, v| arr << "#{k}=#{v}" if v }
    arr.sort.join('&')
  end
end
