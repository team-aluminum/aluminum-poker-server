class Room < ApplicationRecord

  before_create :generate_keys

  def self.generate_keys
    key1 = "#{%w(s h d c).sample}#{(1..13).to_a.sample}"
    key2 = "#{%w(s h d c).sample}#{(1..13).to_a.sample}"
    self.keys = "#{key1},#{key2}"
  end
end
