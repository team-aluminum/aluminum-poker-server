class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.integer :room_id
      t.string :code, null: false
      t.boolean :hosting, default: false
      t.string :keys
      t.timestamps
    end
  end
end
