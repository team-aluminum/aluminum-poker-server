class RoomCard < ApplicationRecord

  belongs_to :room
  belongs_to :user, optional: true

  enum card_type: {
    user: 0,
    flop: 1,
    turn: 2,
    river: 3,
  }
end
