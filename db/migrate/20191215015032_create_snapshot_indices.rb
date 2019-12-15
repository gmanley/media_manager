class CreateSnapshotIndices < ActiveRecord::Migration[5.2]
  def change
    create_table :snapshot_indices do |t|
      t.integer :grid_size, array: true, default: [3, 3]
      t.string :image
      t.belongs_to :video
      t.timestamps
    end
  end
end
