require "test_helper"

class TokensControllerGeneratorTest < Rails::Generators::TestCase
  include GeneratorsTestHelper

  tests Knocknock::TokensControllerGenerator
  destination File.expand_path("../tmp", File.dirname(__FILE__))

  setup :prepare_destination
  setup :copy_routes

  test "assert all files are properly created" do
    run_generator ['User']
    assert_file "app/controllers/user_tokens_controller.rb"

    run_generator ['Api::V1::Admin']
    assert_file "app/controllers/api/v1/admin_tokens_controller.rb"
  end
end
