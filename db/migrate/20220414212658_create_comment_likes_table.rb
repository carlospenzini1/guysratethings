class CreateCommentLikesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :comment_likes do |t|
      t.integer :comment_id, null: false
      t.integer :user_id, null: false
    end
  end
end
