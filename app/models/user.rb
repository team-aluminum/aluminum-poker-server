class User < ApplicationRecord

  has_one :mobile_user
  belongs_to :room, optional: true

  before_create :set_code

  # @param key<String> ex) s7
  def add_key(key)
    if keys.to_s.size == 0
      update(keys: key)
    elsif keys.to_s.split(?,).size == 1
      self.keys = "#{keys},#{key}"
      self.room_id = Room.find_by(keys: self.keys)&.id
      save
    end
  end

  private

    def set_code
      self.code = SecureRandom.urlsafe_base64
    end
end
