require_relative 'sha256_signature'

class AccountInformation
  include SHA256Signature

  def initialize(client, timestamp=(Time.now.to_f*1000).to_i, **options)
    @client = client
    @timestamp = timestamp
    @options = {
      recvWindow: options[:recvWindow]
    }
  end

  def call_to_api
    @client.connection.get do |request|
      request.url 'api/v3/account'
      request.headers["X-MBX-APIKEY"] = @client.api_key
      request.params['timestamp'] = @timestamp
      request.params['recvWindow'] = @options[:recvWindow] if @options[:recvWindow]
      request.params['signature'] = sha256_code
    end
  end
end
