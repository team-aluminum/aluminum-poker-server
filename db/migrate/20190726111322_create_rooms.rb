class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.string :keys, null: false
      t.boolean :preparing, default: true
      t.timestamps
    end
  end
end
