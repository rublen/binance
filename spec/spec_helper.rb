require_relative '../environments/test'
require 'dotenv'
require 'vcr'
require 'webmock/rspec'
require 'json_spec'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.ignore_hosts '127.0.0.1', 'localhost'
  c.hook_into :webmock
  c.default_cassette_options = { record: :new_episodes }
end

RSpec.configure do |c|
  # c.include JsonSpec::Helpers
end
