require 'test_helper'

class AccessTokenTest < ActiveSupport::TestCase
  test 'ensure token is never blank' do
    access_token = AccessToken.new
    access_token.save
    refute_empty access_token.token
  end
end
