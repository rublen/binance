class BinanceClient
  BASE_ENDPOINT = 'https://api.binance.com/'

  attr_reader :credential_id, :connection, :api_key

  def initialize(credential)
    @credential_id = credential.id
    @api_key = credential.api_key
    @api_secret = credential.api_secret
    @connection = Faraday.new(url: BASE_ENDPOINT)
  end
end
