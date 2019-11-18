class CreateShows < ActiveRecord::Migration[5.1]
  def change
    create_table :shows do |t|
      t.string :venue
      t.date :date
      t.text :first_set
      t.text :second_set
      t.text :encore

      t.timestamps
    end
  end
end
