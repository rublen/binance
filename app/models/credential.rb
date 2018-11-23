class Credential < ActiveRecord::Base
  validates :api_key, presence: true, uniqueness: true
  validates :api_secret, presence: true, uniqueness: true
end
