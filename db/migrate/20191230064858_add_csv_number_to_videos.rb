class AddCsvNumberToVideos < ActiveRecord::Migration[5.2]
  def change
    add_column :videos, :csv_number, :integer, index: true
  end
end
