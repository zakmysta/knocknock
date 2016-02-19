require 'jwt'

module Knocknock
  class AuthToken
    attr_reader :token
    attr_reader :payload

    def initialize payload: {}, token: nil
      if token.present?
        @payload, _ = JWT.decode token, decode_key, true, options
        @token = token
      else
        @payload = payload
        @token = JWT.encode claims.merge(payload),
          secret_key,
          Knocknock.token_signature_algorithm
      end
    end

    def access_token
      AccessToken.find_by(token: @payload['sub'])
    end

    def resource resource_class
      AccessToken.find_by(token: @payload['sub'], 
                          authenticatee_type: resource_class.to_s).authenticatee
    end

    def to_json
      { jwt: @token }.to_json
    end

  private
    def secret_key
      Knocknock.token_secret_signature_key.call
    end

    def decode_key
      Knocknock.token_public_key || secret_key
    end

    def options
      verify_claims.merge({
        algorithm: Knocknock.token_signature_algorithm
      })
    end

    def claims
      {
        exp: Knocknock.token_lifetime.from_now.to_i,
        aud: token_audience
      }
    end

    def verify_claims
      {
        aud: token_audience, verify_aud: verify_audience?
      }
    end

    def token_audience
      verify_audience? && Knocknock.token_audience.call
    end

    def verify_audience?
      Knocknock.token_audience.present?
    end
  end
end
