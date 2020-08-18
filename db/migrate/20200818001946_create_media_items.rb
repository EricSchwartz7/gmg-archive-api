class CreateMediaItems < ActiveRecord::Migration[5.1]
  def change
    create_table :media_items do |t|
      t.string :public_id
      t.integer :show_id
      t.integer :media_type
      t.string :title

      t.timestamps
    end
  end
end
