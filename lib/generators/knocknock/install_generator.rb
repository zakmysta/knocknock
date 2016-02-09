module Knocknock
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("../../templates", __FILE__)

    desc "Creates a Knocknock initializer and an AccessToken model"

    def copy_initializer
      template 'knocknock.rb', 'config/initializers/knocknock.rb'
    end

    def create_access_token_migration
      template 'create_access_token.rb', 
               "db/migrate/#{Time.now.strftime("%Y%m%d%H%M%S")}_create_access_token.rb"
    end

    def copy_access_token_model
      template 'access_token.rb', 'app/models/access_token.rb'
    end
  end
end
