require_relative '../environments/test'
require 'vcr'
require 'webmock/rspec'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.ignore_hosts '127.0.0.1', 'localhost'
  c.hook_into :webmock
end

RSpec.configure do |c|
end
