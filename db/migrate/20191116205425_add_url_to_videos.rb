class AddUrlToVideos < ActiveRecord::Migration[5.1]
  def change
    add_column :videos, :url, :string
  end
end
