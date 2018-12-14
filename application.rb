require 'yaml'
require 'singleton'
require 'active_record'
require 'logger'


require 'dotenv'
class Application

  include Singleton

  @logger = Logger.new(File.expand_path('log/app.log', __dir__), 10, 1024000)

  attr_reader :db

  def initialize
    @db = nil
  end

  def run!
    setup_database
    require_app
  end

  def root
    Pathname.new(File.expand_path('..', __FILE__))
  end

  def self.log(level, data)
    @logger.public_send(level, data)
  end

  private

  def require_app
    Dir["#{root}/app/**/*.rb"].each { |file| require file }
  end

  def setup_database
    db_configuration
    @db = ActiveRecord::Base.establish_connection(db_configuration[$environment])
  end

  def db_configuration
    db_configuration_file = root.join('db', 'config.yml')
    YAML.load(File.read(db_configuration_file))
  end
end
