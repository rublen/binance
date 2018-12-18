require 'faraday'

class BinanceClient
  BASE_ENDPOINT = 'https://api.binance.com/'

  attr_reader :connection

  def initialize(credential)
    @credential = credential
    @connection = Faraday.new(url: BASE_ENDPOINT)
    @api_urls = {
      all_orders: 'api/v3/allOrders',
      account_trade_list: 'api/v3/myTrades',
      account_information: 'api/v3/account'
    }
  end

  def credential_id
    @credential.id
  end

  def account_information(params)
    account_call(@api_urls[:account_information], params)
  end

  def account_trade_list(params)
    account_call(@api_urls[:account_trade_list], params)
  end

  def all_orders(params)
    account_call(@api_urls[:all_orders], params)
  end

  def account_call(url, query_params = {})
  # account_information: mandatory parameters - :timestamp; optional parameters - :recvWindow
  # account_trade_list: mandatory - :symbol, :timestamp; optional - :start_time, :end_time, :limit, :fromId, :recvWindow
  # all_orders: mandatory - :symbol, :timestamp; optional - :start_time, :end_time, :limit, :orderId, :recvWindow
    params = { timestamp: timestamp, **query_params }
    @connection.get do |request|
      request.url url
      request.headers["X-MBX-APIKEY"] = @credential.api_key
      request.params.merge!(params)
      request.params['signature'] = sha256_code(params) if @credential
    end
  end

  def public_call(url)
    connection.get(url)
  end


  private

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
