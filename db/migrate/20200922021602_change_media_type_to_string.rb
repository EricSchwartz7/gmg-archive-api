class ChangeMediaTypeToString < ActiveRecord::Migration[5.1]
  def change
    change_column :media_items, :media_type, :string
  end
end
