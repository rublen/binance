class AllOrders
  include SHA256Signature

  def initialize(client, symbol_string, timestamp=(Time.now.to_f*1000).to_i, **options)
    @client = client
    @symbol = symbol_string
    @timestamp = timestamp
    @options = {
      start_time: options[:start_time],
      end_time: options[:end_time],
      limit: options[:limit],
      orderId: options[:orderId],
      recvWindow: options[:recvWindow]
    }
  end

  def call_to_api
    @client.connection.get do |request|
      request.url 'api/v3/allOrders'
      request.headers["X-MBX-APIKEY"] = @client.api_key
      request.params['symbol'] = @symbol
      request.params['timestamp'] = @timestamp
      request.params['start_time'] = @options[:start_time] if @options[:start_time]
      request.params['end_time'] = @options[:end_time] if @options[:end_time]
      request.params['limit'] = @options[:limit] if @options[:limit]
      request.params['orderId'] = @options[:orderId] if @options[:orderId]
      request.params['recvWindow'] = @options[:recvWindow] if @options[:recvWindow]
      request.params['signature'] = sha256_code
    end
  end

  def raw_response
    response = call_to_api
    response_body = JSON.parse(response.body)
    Application.log(:error, "401 Unauthorized: #{response_body}") if response.status >= 400
    response_body
  end
end
