class CreateMobileUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :mobile_users do |t|
      t.integer :user_id
      t.timestamps
    end
  end
end
