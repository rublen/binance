require 'spec_helper'

class Hash
  def method_missing(method_name)
    # p "missing method: #{method_name.inspect}"
    self[method_name] if keys.include? method_name
  end
end


describe "Binance API requests with VCR-RSpec integration" do
  credential = { id: 1, api_key: ENV["API_KEY"], api_secret: ENV["API_SECRET"] }
  let(:client) { BinanceClient.new(credential) }


  let(:url) {'/api/v1/ping'}

  context "Public call to api", :vcr do
    it 'records an http request' do
      VCR.use_cassette("ping") do
        expect(JSON.parse(client.call(url).body)).to be_a(Hash)
      end
    end
  end

  context "Account information" do
    let(:account_information) { VCR.use_cassette("account_information") { client.account_information(recvWindow: 5000) } }

    it 'returns status 200' do
      expect(account_information.status).to eq 200
    end

    it 'returns hash' do
      expect(JSON.parse(account_information.body)).to be_a Hash
    end

    it 'contains array balances' do
      expect(account_information.body).to have_json_type(Array).at_path("balances")
    end
  end


  context "Account trade list" do
    let(:account_trade_list) { VCR.use_cassette("account_trade_list") { r = client.account_trade_list(symbol: 'ETHBTC', limit: 2) } }

    it 'returns status 200' do
      expect(account_trade_list.status).to eq 200
    end

    it 'returns array' do
      expect(JSON.parse(account_trade_list.body)).to be_a Array
    end

    %w(date symbol type price quantity).each do |attr|
      it "contains #{attr}" do
        expect(account_trade_list.body).to have_json_path("0/#{attr}")
      end
    end
  end

  context "Account all orders" do
    let(:all_orders) { VCR.use_cassette("all_orders") { client.all_orders(symbol: 'ETHBTC', limit: 2) } }

    it 'returns status 200' do
      expect(all_orders.status).to eq 200
    end

    it 'returns array' do
      expect(JSON.parse(all_orders.body)).to be_a Array
    end
  end
end
