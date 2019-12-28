class RemovePathFromVideos < ActiveRecord::Migration[5.2]
  def change
    remove_column :videos, :file_path, :string
  end
end
