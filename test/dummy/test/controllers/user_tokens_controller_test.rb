require 'test_helper'

class UserTokensControllerTest < ActionController::TestCase
  def setup
    request.accept = 'application/json'
    @user = users(:one)
  end

  def valid_token_auth
    @token = Knocknock::AuthToken.new(payload: { sub: @user.access_tokens.create.token }).token
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{@token}"
  end

  def invalid_token_auth
    @token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{@token}"
  end

  test "responds with 404 if user does not exist" do
    post :create, params: { auth: { email: 'wrong@example.net', password: '' } }
    assert_response :not_found
  end

  test "responds with 404 if password is invalid" do
    post :create, params: { auth: { email: @user.email, password: 'wrong' } }
    assert_response :not_found
  end

  test "responds with 201" do
    post :create, params: { auth: { email: @user.email, password: 'password' } }
    assert_response :created
    assert JSON.parse(response.body).keys.include?('jwt')
  end

  test 'destroy responds with 401 for invalid token' do
    invalid_token_auth
    delete :destroy
    assert_response :unauthorized
  end

  test 'destroy responds with 200 for valid token' do
    valid_token_auth
    delete :destroy
    assert_response :ok
  end

  test 'destroy responds with 401 for deleted token' do
    valid_token_auth
    delete :destroy
    assert_response :ok
    delete :destroy
    assert_response :unauthorized
  end
end
