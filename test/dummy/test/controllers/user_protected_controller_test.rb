require 'test_helper'

class UserProtectedControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end

  def valid_auth
    @token = Knocknock::AuthToken.new(payload: { sub: @user.access_tokens.create.token }).token
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
    get '/user_protected'
    assert_response :unauthorized
  end

  test "responds with unauthorized to invalid token" do
    get '/user_protected', headers: invalid_token_auth
    assert_response :unauthorized
  end

  test "responds with unauthorized to invalid resource" do
    get '/user_protected', headers: invalid_resource_auth
    assert_response :unauthorized
  end

  test "responds with success if authenticated" do
    get '/user_protected', headers: valid_auth
    assert_response :success
  end

  test "has a current_user after authentication" do
    get '/user_protected', headers: valid_auth
    assert_response :success
    assert @controller.current_user.id == @user.id
  end
end
