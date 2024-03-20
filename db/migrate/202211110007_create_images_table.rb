class CreateImagesTable < ActiveRecord::Migration[4.2]
  def change
     create_table :images do |t|
       t.string :img
  end
  end
end
