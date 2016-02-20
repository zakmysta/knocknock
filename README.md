# knocknock
[![Gem Version](https://badge.fury.io/rb/knocknock.svg)](https://badge.fury.io/rb/knocknock)
[![Build Status](https://travis-ci.org/zakmysta/knocknock.svg?branch=master)](https://travis-ci.org/zakmysta/knocknock)
[![Test Coverage](https://codeclimate.com/github/zakmysta/knocknock/badges/coverage.svg)](https://codeclimate.com/github/zakmysta/knocknock/coverage)
[![Code Climate](https://codeclimate.com/github/zakmysta/knocknock/badges/gpa.svg)](https://codeclimate.com/github/zakmysta/knocknock)
[![Dependency Status](https://gemnasium.com/zakmysta/knocknock.svg)](https://gemnasium.com/zakmysta/knocknock)

Seamless multi-model, multi-client JWT authentication for Rails API

## Description

Knocknock is an authentication solution for Rails API applications based on JSON Web Tokens.

### What are JSON Web Tokens?

[![JWT](http://jwt.io/assets/badge.svg)](http://jwt.io/)

### Why should I use this?

- It's lightweight.
- It's tailored for Rails API-only application.
- It's [stateless](https://en.wikipedia.org/wiki/Representational_state_transfer#Stateless).

### Is this gem going to be maintained?

Yes. And we will keep improving it.

## Getting Started

### Requirements

knocknock makes one assumption about your user model:

It must have an `authenticate` method, similar to the one added by [has_secure_password](http://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html#method-i-has_secure_password).

```ruby
class User < ActiveRecord::Base
  has_secure_password
end
```

Using `has_secure_password` is recommended, but you don't have to as long as your user model implements an `authenticate` instance method with the same behavior.

knocknock can handle multiple user models (eg: User, Admin, etc). For the sake of simplicity, all examples in this README will use the `User` model.

### Installation

Add this line to your application's Gemfile:

```ruby
gem 'knocknock'
```

And then execute:

    $ bundle install

Finally, run the install generator:

    $ rails generate knocknock:install

This creates three files:
1. The knocknock initializer `config/initializers/knocknock.rb`. This file contains all the informations about the existing configuration options.
2. The AccessToken model.
3. The related migration for the AccessToken model.

You also need to provide a way for users to authenticate:

    $ rails generate knocknock:token_controller user

This will generate the controller `user_token_controller.rb` and add the required
route to your `config/routes.rb` file.

### Usage

For each model you want to use with knocknock, add the
`has_many :access_tokens, as: :authenticatee` association

```ruby
class User < ApplicationRecord
  has_many :access_tokens, as: :authenticatee
  ...
end
```

Include the `Knocknock::Authenticatable` module in your `ApplicationController`

```ruby
class ApplicationController < ActionController::API
  include Knocknock::Authenticatable
end
```

You can now restrict access to your controllers like this:

```ruby
class SecuredController < ApplicationController
  before_action :authenticate_user

  def index
    # etc...
  end

  # etc...
end
```

If your user model is something other than User, replace "user" with "yourmodel". The same logic applies everywhere.

You can access the current authenticated user in your controller with this method:

```ruby
current_user
```

If no valid token is passed with the request, Knock will respond with:

```
head :unauthorized
```

### Authenticating from a web or mobile application:

Example request to get a token from your API:
```
POST /user_tokens
{"auth": {"email": "foo@bar.com", "password": "secret"}}
```

Example response from the API:
```
201 Created
{"jwt": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9"}
```

To make an authenticated request to your API, you need to pass the token in the request header:
```
Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9
GET /my_resources
```

**NB:** HTTPS should always be enabled when sending a password or token in your request.

### Authenticated tests

To authenticate within your tests:

1. Create a valid token
2. Pass it in your request

e.g.

```ruby
class SecuredControllerTest < ActionController::TestCase
  def authenticate
    token = Knock::AuthToken.new(payload: { sub: users(:one).id }).token
    request.env['HTTP_AUTHORIZATION'] = "Bearer #{token}"
  end

  setup do
    authenticate
  end

  it 'responds successfully' do
    get :index
    assert_response :success
  end
end
```

### Algorithms

The JWT spec supports different kind of cryptographic signing algorithms.
You can set `token_signature_algorithm` to use the one you want in the
initializer or do nothing and use the default one (HS256).

You can specify any of the algorithms supported by the
[jwt](https://github.com/jwt/ruby-jwt) gem.

If the algorithm you use requires a public key, you also need to set
`token_public_key` in the initializer.

## CORS

To enable cross-origin resource sharing, check out the [rack-cors](https://github.com/cyu/rack-cors) gem.

## Related links

- [10 things you should know about tokens](https://auth0.com/blog/2014/01/27/ten-things-you-should-know-about-tokens-and-cookies/)

## Contributing

1. Fork it ( https://github.com/nsarno/knock/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

MIT
