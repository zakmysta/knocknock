require 'test_helper'

class UserTokensControllerTest < ActionController::TestCase
  def setup
    request.accept = 'application/json'
    @user = users(:one)
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
end
