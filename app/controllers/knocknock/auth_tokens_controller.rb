module Knocknock
  class AuthTokensController < ActionController::API
    before_action :authenticate, only: :create
    before_action :authenticate_resource, only: :destroy

    def create
      render json: auth_token, status: :created
    end

    def destroy
      @access_token.destroy
      head :ok
    end

  private
    def authenticate
      unless resource.present? && resource.authenticate(auth_params[:password])
        head :not_found
      end
    end

    def authenticate_resource
      token = request.headers['Authorization'].split(' ').last
      @access_token = Knocknock::AuthToken.new(token: token).access_token
      head :unauthorized if @access_token.nil?
    rescue
      head :unauthorized
    end

    def auth_token
      AuthToken.new payload: { sub: resource.access_tokens.create.token }
    end

    def auth_params
      params.require(:auth).permit!
    end

    def resource
      @resource ||= 
        if resource_class.respond_to? :find_for_token_creation
          resource_class.find_for_token_creation auth_params
        else
          resource_class.find_by email: auth_params[:email]
        end
    end

    def resource_class
      resource_name.constantize
    end

    def resource_name
      self.class.name.demodulize.split('TokensController').first
    end
  end
end
