class AccessToken < ApplicationRecord
  before_create :generate_token

  belongs_to :authenticatee, polymorphic: true

  private

    def generate_token
      loop do
        self.token = SecureRandom.uuid
        break unless self.class.exists?(token: token)
      end
    end
end
