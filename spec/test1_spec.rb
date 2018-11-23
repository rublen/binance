require 'spec_helper'

class Hash
  def method_missing(method_name)
    p "missing method: #{method_name.inspect}"
    self[method_name] if keys.include? method_name
  end
end


describe "VCR-RSpec integration" do
  credential = { id: 1, api_key: 'XXX', api_secret: 'secret' }
  let(:client) { BinanceClient.new(credential) }
  let(:historical_trade) { HistoricalTrades.new(client, 'ETHBTC', 1)}

  context "call_to_api", :vcr do
    it 'records an http request' do
      VCR.use_cassette("historical_trades") do
        expect(historical_trade.call_to_api).to_not eq(nil)
      end
    end
  end

  context "raw_response" do
    it 'records an http request' do
      VCR.use_cassette("historical_trades") do
        expect(historical_trade.raw_response).to_not eq(nil)
      end
    end
  end
end
