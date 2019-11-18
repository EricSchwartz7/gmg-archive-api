class CreateAudioRecs < ActiveRecord::Migration[5.1]
  def change
    create_table :audio_recs do |t|
      t.string :title
      t.integer :show_id

      t.timestamps
    end
  end
end
