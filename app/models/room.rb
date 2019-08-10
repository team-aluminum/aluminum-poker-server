class Room < ApplicationRecord

  has_many :users
  has_many :mobile_users, through: :users
  has_many :room_cards

  before_create :generate_keys

  enum status: {
    preparing: 0,
    drawing: 1,
    preflop: 2,
    flop: 3,
    turn: 4,
    river: 5,
    result: 6,
  }

  def preflopen
    preflop!
    sb_user = users.find_by(button: true)
    bb_user = users.find_by(button: false)

    sb_user.update(betting: 1, chips: sb_user.chips - 1, active: true)
    bb_user.update(betting: 2, chips: bb_user.chips - 2)
  end

  def opposite_user(user)
    users.where.not(id: user.id).first
  end

  def next_phase
    update(pod_chips: pod_chips + users.map { |u| u.betting }.inject(:+))
    users.update(betting: 0, limp: false)
    if preflop?
      flop!
      3.times { RoomCard.draw(self) }
    elsif flop?
      turn!
      RoomCard.draw(self)
    elsif turn?
      river!
      RoomCard.draw(self)
    elsif river?
      result!
      u1 = users.first
      u2 = users.last
      u1_hand = best_hand(u1)
      u2_hand = best_hand(u2)
      if u1_hand[0] < u2_hand[0]
        u1.update(result: 'win', result_countdown: 10)
        u2.update(result: 'lose', result_countdown: 10)
      elsif u1_hand[0] > u2_hand[0]
        u1.update(result: 'lose', result_countdown: 10)
        u2.update(result: 'win', result_countdown: 10)
      else
        u1.update(result: 'draw', result_countdown: 10)
        u2.update(result: 'draw', result_countdown: 10)
      end
    end
  end

  def flop_cards
    room_cards.where(card_type: :flop)
  end

  def turn_card
    room_cards.find_by(card_type: :turn)
  end

  def river_card
    room_cards.find_by(card_type: :river)
  end

  def get_rank
    users.map do |u|
      best_hand(u)
    end
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

    def best_hand(user)
      current_rank = [10, nil]
      all_cards = room_cards.where(user_id: [nil, user.id])
      all_cards.to_a.combination(5).to_a.each do |_cards|
        rank = evaluate(_cards)
        current_rank = rank if current_rank[0] > rank[0]
      end
      current_rank
    end

    def evaluate(cards)
      if royal?(cards) && flush?(cards)
        [0, 'Royal Flush']
      elsif straight?(cards) && flush?(cards)
        [1, 'Straight Flush']
      elsif four_card?(cards)
        [2, 'Four of a Kind']
      elsif full_house?(cards)
        [3, 'Full House']
      elsif flush?(cards)
        [4, 'Flush']
      elsif straight?(cards)
        [5, 'Straight']
      elsif three_card?(cards)
        [6, 'Three of a Kind']
      elsif two_pair?(cards)
        [7, 'Two Pair']
      elsif one_pair?(cards)
        [8, 'One Pair']
      else
        [9, 'Hight Card']
      end
    end

    def numbers(cards)
      cards.map(&:number).sort
    end

    def suits(cards)
      cards.map(&:suit)
    end

    def royal?(cards)
      numbers(cards) == [1, 10, 11, 12, 13]
    end

    def straight?(cards)
      royal?(cards) || (numbers(cards).uniq.size == 5 && numbers(cards)[-1] - numbers(cards)[0] == 4)
    end

    def flush?(cards)
      suits(cards).uniq.size == 1
    end

    def full_house?(cards)
      numbers(cards).group_by { |n| n }.map { |_, g| g.size }.sort == [2, 3]
    end

    def four_card?(cards)
      numbers(cards).group_by { |n| n }.map { |_, g| g.size }.sort == [1, 4]
    end

    def three_card?(cards)
      numbers(cards).group_by { |n| n }.map { |_, g| g.size }.sort == [1, 1, 3]
    end

    def two_pair?(cards)
      numbers(cards).group_by { |n| n }.map { |_, g| g.size }.sort == [1, 2, 2]
    end

    def one_pair?(cards)
      numbers(cards).group_by { |n| n }.map { |_, g| g.size }.sort == [1, 1, 1, 2]
    end
end
