require "test_helper"

class InstallGeneratorTest < Rails::Generators::TestCase
  tests Knocknock::InstallGenerator
  destination File.expand_path("../tmp", File.dirname(__FILE__))

  setup :prepare_destination

  test "assert all files are properly created" do
    run_generator
    assert_file "config/initializers/knocknock.rb"
    assert_migration 'db/migrate/create_access_token.rb'
    assert_file 'app/models/access_token.rb'
  end
end
