require 'json'
require 'pp'
require 'active_record'
require_relative 'binance'
require_relative 'models/credential'


def root
  Pathname.new(File.expand_path('..', __FILE__))
end

def db_configuration
  db_configuration_file = root.join('db', 'config.yml')
  YAML.load(File.read(db_configuration_file))
end

ActiveRecord::Base.establish_connection(db_configuration["development"])

client = Binance.new(Credential.last)

pp arr = JSON.parse(client.hystorical_trades_call('ETHBTC', 5).body)
a = arr.select { |h| h['id'] = 91857071 }
pp a
# pp 'Hystorical Trades:', JSON.parse(client.public_call.body)
# pp('Hystorical Trades:', JSON.parse(client.public_call('/api/v1/exchangeInfo').body))
