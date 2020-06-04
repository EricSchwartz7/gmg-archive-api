class RemoveEncoreFromShows < ActiveRecord::Migration[5.1]
  def change
    remove_column :shows, :encore, :text
  end
end
