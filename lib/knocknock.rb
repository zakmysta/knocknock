require "knocknock/engine"

module Knocknock

  mattr_accessor :token_lifetime
  self.token_lifetime = 1.day

  mattr_accessor :token_audience
  self.token_audience = nil

  mattr_accessor :token_signature_algorithm
  self.token_signature_algorithm = 'HS256'

  mattr_accessor :token_secret_signature_key
  self.token_secret_signature_key = -> { Rails.application.secrets.secret_key_base }

  mattr_accessor :token_public_key
  self.token_public_key = nil

  # Default way to setup Knocknock. Run `rails generate knocknock:install` to
  #create a fresh initializer and AccessToken model.
  def self.setup
    yield self
  end
end
