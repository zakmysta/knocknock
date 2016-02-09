class User < ApplicationRecord
  has_many :access_tokens, as: :authenticatee
  
  has_secure_password
end
