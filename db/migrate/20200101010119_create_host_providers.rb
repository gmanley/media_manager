class CreateHostProviders < ActiveRecord::Migration[5.2]
  def change
    create_table :host_providers do |t|
      t.string :url, null: false
      t.string :name, null: false, index: true
      t.bigint :default_storage_limit
      t.timestamps
    end
  end
end
