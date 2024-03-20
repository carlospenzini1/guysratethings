class Addguypoints < ActiveRecord::Migration[5.2]
  def change
    add_column :g_users, :guypoints, :integer
  end
end
