class AddPositionToShowSongs < ActiveRecord::Migration[5.1]
  def change
    add_column :show_songs, :position, :integer
  end
end
