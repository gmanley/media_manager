class CreateUploads < ActiveRecord::Migration[5.2]
  def change
    create_table :uploads do |t|
      t.string :url, null: false
      t.string :remote_path
      t.boolean :online, null: false, default: true, index: true
      t.boolean :public, null: false, default: true, index: true
      t.belongs_to :host_provider
      t.belongs_to :host_provider_account
      t.belongs_to :video
      t.timestamps
    end
  end
end
