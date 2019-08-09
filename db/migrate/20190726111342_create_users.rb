class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.integer :room_id
      t.string :code, null: false
      t.boolean :hosting, default: false
      t.string :keys
      t.string :peer_id
      t.integer :chips
      t.boolean :button, default: false
      t.boolean :active, default: false
      t.timestamps
    end
  end
end
