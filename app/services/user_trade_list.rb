require 'openssl'

class UserTradeList
  def initialize(client, symbol_string, timestamp=(Time.now.to_f*1000).to_i, **options)
    @client = client
    @symbol = symbol_string
    @timestamp = timestamp
    @options = {
      start_time: options[:start_time],
      end_time: options[:end_time],
      limit: options[:limit],
      fromId: options[:fromId],
      recv_window: options[:recv_window]
    }
  end

  def call_to_api
    @client.connection.get do |request|
      request.url 'api/v3/myTrades'
      request.headers["X-MBX-APIKEY"] = @client.api_key
      request.params['symbol'] = @symbol
      request.params['timestamp'] = @timestamp
      request.params['start_time'] = @options[:start_time] if @options[:start_time]
      request.params['end_time'] = @options[:end_time] if @options[:end_time]
      request.params['limit'] = @options[:limit] if @options[:limit]
      request.params['fromId'] = @options[:fromId] if @options[:fromId]
      request.params['recv_window'] = @options[:recv_window] if @options[:recv_window]
      request.params['signature'] = sha256_code
    end
  end

  def raw_response
    response = call_to_api
    response_body = JSON.parse(response.body)
    Application.log(:error, "401 Unauthorized: #{response_body}") if response.status >= 400
    response_body
  end

  private

  def total_params
    params = ["symbol=#{@symbol}", "timestamp=#{@timestamp}"]
    @options.each do |k, v|
      params << "#{k}=#{v}" if v
    end
    params.sort.join('&')
  end

  def sha256_code
    key = @client.api_secret
    data = total_params
    OpenSSL::HMAC.hexdigest("SHA256", key, data)
  end
end

