class CreateCommentsTable < ActiveRecord::Migration[4.2]
  def change
    create_table :comments do |t|
      t.string :text, null: false
      t.datetime :created_at, null: false
      t.integer :list_id, null: false
      t.integer :user_id, null: false
      t.integer :likes, null: false
    end
  end
end
