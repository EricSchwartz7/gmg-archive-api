class CreateMediaItemSongs < ActiveRecord::Migration[5.1]
  def change
    create_table :media_item_songs do |t|
      t.integer :media_item_id
      t.integer :song_id

      t.timestamps
    end
  end
end
