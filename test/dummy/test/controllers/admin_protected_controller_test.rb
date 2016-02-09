require 'test_helper'

class AdminProtectedControllerTest < ActionController::TestCase
  def valid_auth
    @admin = admins(:one)
    @token = Knocknock::AuthToken.new(payload: { sub: @admin.access_tokens.create.token }).token
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{@token}"
  end

  def invalid_token_auth
    @token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{@token}"
  end

  def invalid_resource_auth
    @token = Knocknock::AuthToken.new(payload: { sub: 0 }).token
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{@token}"
  end

  test "responds with unauthorized" do
    get :index
    assert_response :unauthorized
  end

  test "responds with unauthorized to invalid token" do
    invalid_token_auth
    get :index
    assert_response :unauthorized
  end

  test "responds with unauthorized to invalid resource" do
    invalid_resource_auth
    get :index
    assert_response :unauthorized
  end

  test "responds with success if authenticated" do
    valid_auth
    get :index
    assert_response :success
  end

  test "has a current_admin after authentication" do
    valid_auth
    get :index
    assert_response :success
    assert @controller.current_admin.id == @admin.id
  end
end
