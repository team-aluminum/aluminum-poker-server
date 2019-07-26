class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.integer :room_id, null: false
      t.string :code, null: false
      t.timestamps
    end
  end
end
