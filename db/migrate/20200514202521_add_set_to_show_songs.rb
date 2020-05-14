class AddSetToShowSongs < ActiveRecord::Migration[5.1]
  def change
    add_column :show_songs, :set, :integer
  end
end
