class AddFilenameToPhotos < ActiveRecord::Migration[5.1]
  def change
    add_column :photos, :filename, :string
  end
end
