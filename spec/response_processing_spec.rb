require 'spec_helper'

describe "ResponseProcessing with VCR-RSpec integration" do
  credential = { id: 1, api_key: ENV["API_KEY"], api_secret: ENV["API_SECRET"] }
  let(:client) { BinanceClient.new(credential) }
  let(:subject) { ResponseProcessing.new(client) }

  context "#raw_response" do
    it "raises error with invalid credentials" do
      client = BinanceClient.new(api_key: '1234', api_secret: '5678')
      subject = ResponseProcessing.new(client)

      VCR.use_cassette("account_trade_list") do
        expect { subject.raw_response(:account_trade_list, symbol: 'ETHBTC', limit: 2) }.to raise_error BinanceException
      end
    end

    it "returns a collection" do
      VCR.use_cassette("account_trade_list") do
        expect(subject.raw_response(:account_trade_list, symbol: 'ETHBTC', limit: 2)).to be_an Array
      end
    end
  end

  context "#response_hash" do
    # Uncomment before-block to stub api requests
    # before do
    #   allow(subject).to receive(:raw_response).with(:account_trade_list, { symbol: 'ETHBTC', limit: 2 }).and_return([])
    #   allow(subject).to receive(:raw_response).with(:account_information, recvWindow: 5000).and_return("balances" => [])
    #   allow(subject).to receive(:time).with(nil)
    # end

    let(:response_hash) { subject.response_hash }

    it "returns a hash" do
      expect(response_hash).to be_a Hash
    end

    it "contains the key :credential_id with integer value" do
      expect(response_hash).to have_key :credential_id
      expect(response_hash.credential_id).to be_an Integer
    end

    it "contains the key :trades with array value" do
      expect(response_hash).to have_key :trades
      expect(response_hash.trades).to be_an Array
    end

    it "contains the key :balances with array value" do
      expect(response_hash).to have_key :balances
      expect(response_hash.balances).to be_an Array
    end
  end
end
