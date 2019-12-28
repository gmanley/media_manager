class CreateSourceFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :source_files do |t|
      t.string :path, null: false, index: true
      t.belongs_to :video
      t.timestamps
    end
  end
end

