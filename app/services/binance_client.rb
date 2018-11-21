class BinanceClient
  BASE_ENDPOINT = 'https://api.binance.com/'

  attr_reader :credential_id, :connection, :api_key

  def initialize(credential)
    @credential_id = credential.id
    @api_key = credential.key
    @api_secret = credential.secret
    @connection = Faraday.new(url: BASE_ENDPOINT)
  end
end
