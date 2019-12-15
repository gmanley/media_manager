class CreateVideos < ActiveRecord::Migration[5.2]
  def change
    create_table :videos do |t|
      t.jsonb :file_metadata
      t.string :file_path, null: false, index: true
      t.string :file_hash
      t.string :name, null: false
      t.date :air_date
      t.decimal :duration
      t.boolean :processed, default: false, null: false
      t.string :download_url
      t.timestamps
    end
  end
end
