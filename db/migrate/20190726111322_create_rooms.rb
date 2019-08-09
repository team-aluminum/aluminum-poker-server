class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.string :keys, null: false
      t.boolean :preparing, default: true
      t.integer :pod_chips
      t.timestamps
    end
  end
end
