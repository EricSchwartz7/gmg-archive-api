class RemoveFirstSetFromShows < ActiveRecord::Migration[5.1]
  def change
    remove_column :shows, :first_set, :text
  end
end
