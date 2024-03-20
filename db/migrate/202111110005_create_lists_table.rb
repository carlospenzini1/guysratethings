class CreateListsTable < ActiveRecord::Migration[4.2]
  def change
    create_table :lists do |t|
      t.integer :user_id, null: false
      t.string :title, null: false
      t.string :lType, null: false
      t.datetime :created_at, null: false
      t.datetime :modified_at
      t.boolean :active, null: false
      t.integer :likes, null: false
      t.boolean :approved, null: false
      t.string :unique, null: false
    end
  end
end
