class RoomCard < ApplicationRecord

  belongs_to :room
  belongs_to :user, optional: true

  enum card_type: {
    user: 0,
    flop: 1,
    turn: 2,
    river: 3,
  }

  def self.draw(room)
    drawn = false
    while !drawn
      suit = %w(s h d c).sample
      number = (1..13).to_a.sample
      if RoomCard.find_by(room_id: room.id, suit: suit, number: number).nil?
        RoomCard.create(room_id: room.id, suit: suit, number: number, card_type: room.status)
        drawn = true
      end
    end
  end
end
