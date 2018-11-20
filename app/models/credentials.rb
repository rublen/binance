require 'active_record'

class Credential < ActiveRecord::Base
  validates :key, presence: true#, uniqueness: true
  validates :secret, presence: true
end
