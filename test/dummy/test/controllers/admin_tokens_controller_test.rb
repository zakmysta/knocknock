require 'test_helper'

class AdminTokensControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin = admins(:one)
  end

  def valid_token_auth
    @token = Knocknock::AuthToken.new(payload: { sub: @admin.access_tokens.create.token }).token
    { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" }
  end

  def invalid_token_auth
    @token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'
    { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" }
  end

  test 'create responds with 404 if user does not exist' do
    post '/admin_tokens', params: { auth: { email: 'wrong@example.net', password: '' } }
    assert_response :not_found
  end

  test 'create responds with 404 if password is invalid' do
    post '/admin_tokens', params: { auth: { email: @admin.email, password: 'wrong' } }
    assert_response :not_found
  end

  test 'create responds with 201 on success' do
    post '/admin_tokens', params: { auth: { email: @admin.email, password: 'password' } }
    assert_response :created
    json = JSON.parse(response.body)
    assert json.keys.include?('jwt')
    auth_token = Knocknock::AuthToken.new(token: json['jwt'])
    assert_equal auth_token.payload['resource_id'], @admin.id
  end

  test 'destroy responds with 401 for invalid token' do
    delete '/admin_tokens', headers: invalid_token_auth
    assert_response :unauthorized
  end

  test 'destroy responds with 200 for valid token' do
    delete '/admin_tokens', headers: valid_token_auth
    assert_response :ok
  end

  test 'destroy responds with 401 for deleted token' do
    auth_header = valid_token_auth
    delete '/admin_tokens', headers: auth_header
    assert_response :ok
    delete '/admin_tokens', headers: auth_header
    assert_response :unauthorized
  end
end
