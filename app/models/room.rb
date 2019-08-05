class Room < ApplicationRecord

  has_many :users
  has_many :mobile_users, through: :users

  before_create :generate_keys

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
