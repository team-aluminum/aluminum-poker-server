class User < ApplicationRecord

  has_one :mobile_user
  belongs_to :room, optional: true

  before_create :set_code

  private

    def set_code
      self.code = SecureRandom.urlsafe_base64
    end
end
