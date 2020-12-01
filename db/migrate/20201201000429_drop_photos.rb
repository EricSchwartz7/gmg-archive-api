class DropPhotos < ActiveRecord::Migration[5.1]
  def change
    drop_table :photos do |t|
      t.integer :show_id
      t.string :filename
      t.timestamps null: false
    end
  end
end
