class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.integer :room_id
      t.string :code, null: false
      t.boolean :hosting, default: false
      t.string :keys
      t.string :peer_id
      t.integer :chips, default: 0
      t.integer :betting, default: 0
      t.integer :phase, default: 0
      t.boolean :limp, default: false
      t.boolean :button, default: false
      t.boolean :active, default: false
      t.string :last_action
      t.timestamps
    end
  end
end
