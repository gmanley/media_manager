class AddPrimarySourceFileIdToVideos < ActiveRecord::Migration[5.2]
  def change
    add_column :videos, :primary_source_file_id, :bigint, null: false
  end
end
