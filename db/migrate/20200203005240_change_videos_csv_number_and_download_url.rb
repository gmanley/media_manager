class ChangeVideosCsvNumberAndDownloadUrl < ActiveRecord::Migration[6.0]
  def up
    rename_column :videos, :csv_number, :external_id
    change_column :videos, :external_id, :string
    remove_column :videos, :download_url
  end

  def down
    add_column :videos, :download_url, :string
    change_column :videos, :external_id, 'integer USING external_id::integer'
    rename_column :videos, :external_id, :csv_number
  end
end
