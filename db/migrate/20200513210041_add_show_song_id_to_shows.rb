class AddShowSongIdToShows < ActiveRecord::Migration[5.1]
  def change
    add_column :shows, :show_song_id, :integer
  end
end
