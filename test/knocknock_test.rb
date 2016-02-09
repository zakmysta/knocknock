require 'test_helper'

class KnocknockTest < ActiveSupport::TestCase
  test 'setup block yields self' do
    Knocknock.setup do |config|
      assert_equal Knocknock, config
    end
  end
end
