class CreateFollowersTable < ActiveRecord::Migration[4.2]
  def change
    create_table :followers do |t|
      t.integer :follower_id, null: false
      t.integer :user_id, null: false
    end 
  end
end
