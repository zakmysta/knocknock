module Knocknock
  class TokensControllerGenerator < Rails::Generators::Base
    source_root File.expand_path("../../templates", __FILE__)
    argument :name, type: :string

    desc <<-DESC
      Creates a Knocknock tokens controller for the given resource
      and add the corresponding routes.
    DESC

    def copy_controller_file
      template 'resource_tokens_controller.rb.erb',
               "app/controllers/#{name.underscore}_tokens_controller.rb"
    end

    private

      def resource_name
        name.underscore.split('/').map(&:capitalize).join('::')
      end
  end
end
