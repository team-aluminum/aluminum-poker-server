class User < ApplicationRecord

  has_one :mobile_user
  has_many :room_cards
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

  def serialize
    {
      code: code,
      peer_id: peer_id,
      chips: chips,
      betting: betting,
      button: button,
      active: active,
      card_count: room_cards.count,
      cards: room_cards,
      result: result,
    }
  end

  private

    def set_code
      self.code = SecureRandom.urlsafe_base64
    end
end
