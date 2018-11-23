require_relative '../environments/test'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  # c.configure_rspec_metadata!
end

RSpec.configure do |c|
  # c.extend VCR::RSpec::Macros # uninitialized constant VCR::RSpec::Macros
end
