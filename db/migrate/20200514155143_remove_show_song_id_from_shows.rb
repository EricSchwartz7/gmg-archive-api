class RemoveShowSongIdFromShows < ActiveRecord::Migration[5.1]
  def change
    remove_column :shows, :show_song_id, :integer
  end
end
