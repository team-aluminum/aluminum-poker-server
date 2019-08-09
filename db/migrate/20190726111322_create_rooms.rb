class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.string :keys, null: false
      t.integer :pod_chips, default: 0
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
