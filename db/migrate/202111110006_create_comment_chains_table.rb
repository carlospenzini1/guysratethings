class CreateCommentChainsTable < ActiveRecord::Migration[4.2]
  def change
    create_table :comment_chains do |t|
     t.integer :parent_id, null:false
     t.integer :child_id, null:false
    end
  end
end
