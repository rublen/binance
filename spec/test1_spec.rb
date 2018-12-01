require 'spec_helper'

class Hash
  def method_missing(method_name)
    p "missing method: #{method_name.inspect}"
    self[method_name] if keys.include? method_name
  end
end


describe "VCR-RSpec integration" do
  credential = { id: 1, api_key: 'XXX', api_secret: 'XXX' }
  let(:client) { BinanceClient.new(credential) }
  let(:historical_trade) { HistoricalTrades.new(client, 'ETHBTC', 1)}
  let(:user_trade_list) { UserTradeList.new(client, 'ETHBTC', limit: 1)}

  let(:url) {'/api/v1/ping'}

  context "call_to_api", :vcr do
    it 'records an http request' do
      VCR.use_cassette("ping") do
        expect(JSON.parse(client.connection.get(url).body)).to be_a(Hash)
      end
    end
  end

  context "historical_trades", :vcr do
    it 'returns status 200' do
      VCR.use_cassette("historical_trades") do
        expect(historical_trade.call_to_api.status).to eq 200
      end
    end

    it 'returns a hash' do
      VCR.use_cassette("historical_trades") do
        expect(historical_trade.raw_response).to be_an Array
      end
    end
  end

  context "user trade list" do
    it 'returns status 200' do
      VCR.use_cassette("user_trade_list") do
        expect(user_trade_list.call_to_api.status).to eq 200
      end
    end
  end
end
