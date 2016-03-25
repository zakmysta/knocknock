require 'test_helper'

class AdminProtectedControllerTest < ActionDispatch::IntegrationTest
  def valid_auth
    @admin = admins(:one)
    @token = Knocknock::AuthToken.new(payload: { sub: @admin.access_tokens.create.token }).token
    { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" }
  end

  def invalid_token_auth
    @token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'
    { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" }
  end

  def invalid_resource_auth
    @token = Knocknock::AuthToken.new(payload: { sub: 0 }).token
    { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" }
  end

  test "responds with unauthorized" do
    get '/admin_protected'
    assert_response :unauthorized
  end

  test "responds with unauthorized to invalid token" do
    get '/admin_protected', headers: invalid_token_auth
    assert_response :unauthorized
  end

  test "responds with unauthorized to invalid resource" do
    get '/admin_protected', headers: invalid_resource_auth
    assert_response :unauthorized
  end

  test "responds with success if authenticated" do
    get '/admin_protected', headers: valid_auth
    assert_response :success
  end

  test "has a current_admin after authentication" do
    get '/admin_protected', headers: valid_auth
    assert_response :success
    assert @controller.current_admin.id == @admin.id
  end
end
