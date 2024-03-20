class CreateListitemsTable < ActiveRecord::Migration[4.2]
  def change
    create_table :list_items do |t|
      t.integer :list_id, null: false
      t.string :description
      t.string :title, null: false
      t.integer :rank, null: false
      t.integer :value, null: false
      t.string :itemimg
    end  
  end
end
