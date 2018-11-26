require 'openssl'

module SHA256Signature
  def total_params
    params = []
    params << "symbol=#{@symbol}" if @symbol
    params << "timestamp=#{@timestamp}" if @timestamp

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
