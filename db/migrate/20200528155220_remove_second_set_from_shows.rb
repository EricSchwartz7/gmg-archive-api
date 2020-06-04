class RemoveSecondSetFromShows < ActiveRecord::Migration[5.1]
  def change
    remove_column :shows, :second_set, :text
  end
end
