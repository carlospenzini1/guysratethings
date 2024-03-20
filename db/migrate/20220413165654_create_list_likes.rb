class CreateListLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :list_likes do |t|
      t.integer :list_id, null: false
      t.integer :user_id, null: false
    end
  end
end
