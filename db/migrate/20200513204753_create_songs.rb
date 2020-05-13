class CreateSongs < ActiveRecord::Migration[5.1]
  def change
    create_table :songs do |t|
      t.string :title
      t.text :lyrics
      t.integer :show_song_id

      t.timestamps
    end
  end
end
