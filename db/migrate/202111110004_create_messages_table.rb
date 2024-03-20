class CreateMessagesTable < ActiveRecord::Migration[4.2]
  def change
    create_table :messages do |t|
      t.datetime :creation_date, null:false
      t.string :text, null:false
      t.integer :recipient_id, null:false
      t.integer :sender_id, null:false
      t.boolean :active, null:false
      t.boolean :read, null:false
    end
  end
end
