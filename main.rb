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

# Credential.create!(key: 'oe9QZ7YcAAQgO4X6o5C2UTO3UORu8RXvBn6wIW7qCC0ah2bME1PGNfcwVtMwh1Fa',
#                    secret: 'hW3NxHfd6v6AeSvDVAPdJBnjIjvhpLj3Am5wLjPYl2ozTmCubKEWnciEvLxDIQjv')

client = Binance.new(Credential.last)

pp 'Hystorical Trades:', JSON.parse(client.hystorical_trades_call('ETHBTC', 5).body)

# pp 'Hystorical Trades:', JSON.parse(client.public_call.body)
# pp('Hystorical Trades:', JSON.parse(client.public_call('/api/v1/exchangeInfo').body))

# Credential.create!(key: 'oe9QZ7YcAAQgO4X6o5C2UTO3UORu8RXvBn6wIW7qCC0ah2bME1PGNfcwVtMwh1Fa',
#                    secret: 'hW3NxHfd6v6AeSvDVAPdJBnjIjvhpLj3Am5wLjPYl2ozTmCubKEWnciEvLxDIQjv')

# p Credential.all
