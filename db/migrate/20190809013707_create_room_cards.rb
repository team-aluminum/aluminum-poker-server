class CreateRoomCards < ActiveRecord::Migration[5.2]
  def change
    create_table :room_cards do |t|
      t.integer :room_id, null: false
      t.integer :user_id
      t.integer :card_type
      t.string :suit
      t.integer :number
      t.timestamps
    end
  end
end
