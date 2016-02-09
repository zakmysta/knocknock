require 'test_helper'
require 'jwt'

module Knocknock
  class AuthTokenTest < ActiveSupport::TestCase
    test "verify algorithm" do
      Knocknock.token_signature_algorithm = 'RS256'
      key = Knocknock.token_secret_signature_key.call

      token = JWT.encode({sub: '1'}, key, 'HS256')

      assert_raises(JWT::IncorrectAlgorithm) {
        AuthToken.new(token: token)
      }
    end

    test "decode RSA encoded tokens" do
      rsa_private = OpenSSL::PKey::RSA.generate 2048
      Knocknock.token_public_key = rsa_private.public_key
      Knocknock.token_signature_algorithm = 'RS256'

      token = JWT.encode({sub: '1'}, rsa_private, 'RS256')

      assert_nothing_raised { AuthToken.new(token: token) }
    end

    test "encode tokens with RSA" do
      rsa_private = OpenSSL::PKey::RSA.generate 2048
      Knocknock.token_secret_signature_key = -> { rsa_private }
      Knocknock.token_signature_algorithm = 'RS256'

      token = AuthToken.new(payload: {sub: '1'}).token

      payload, header = JWT.decode token, rsa_private.public_key, true
      assert_equal payload['sub'], '1'
      assert_equal header['alg'], 'RS256'
    end

    test "verify audience when token_audience is present" do
      Knocknock.token_audience = -> { 'bar' }
      key = Knocknock.token_secret_signature_key.call

      token = JWT.encode({sub: 'foo'}, key, 'HS256')

      assert_raises(JWT::InvalidAudError) {
        AuthToken.new token: token
      }
    end
  end
end
