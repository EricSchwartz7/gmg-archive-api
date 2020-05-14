class RemoveShowSongIdFromSongs < ActiveRecord::Migration[5.1]
  def change
    remove_column :songs, :show_song_id, :integer
  end
end
