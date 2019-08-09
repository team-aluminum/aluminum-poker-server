class Room < ApplicationRecord

  has_many :users
  has_many :mobile_users, through: :users
  has_many :room_cards

  before_create :generate_keys

  enum status: {
    preparing: 0,
    drawing: 1,
    preflop: 2,
  }

  def preflopen
    self.status = :preflop
    sb_user = users.find_by(button: true)
    bb_user = users.find_by(button: false)

    sb_user.update(betting: 1, chips: sb_user.chips - 1, active: true)
    bb_user.update(betting: 2, chips: bb_user.chips - 2)
  end

  def opposite_user(user)
    users.where.not(id: user.id).first
  end

  private

    def generate_keys
      key1 = "#{%w(s h d c).sample}#{(1..13).to_a.sample}"
      key2 = nil
      while key2.nil? || key2 == key1 do
        key2 = "#{%w(s h d c).sample}#{(1..13).to_a.sample}"
      end
      self.keys = "#{key1},#{key2}"
    end
end
