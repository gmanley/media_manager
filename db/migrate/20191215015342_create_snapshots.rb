class CreateSnapshots < ActiveRecord::Migration[5.2]
  def change
    create_table :snapshots do |t|
      t.decimal :video_time, null: false
      t.boolean :processed, default: false, null: false
      t.string :image
      t.belongs_to :snapshot_index
      t.timestamps
    end
  end
end
