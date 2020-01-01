class CreateUploads < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          CREATE TYPE host_providers AS ENUM (
            'mega',
            'backblaze'
          );
        SQL
      end

      dir.down do
        execute <<-SQL
          DROP TYPE host_providers;
        SQL
      end
    end

    create_table :uploads do |t|
      t.string :url, null: false
      t.boolean :online, null: false, default: true, index: true
      t.boolean :public, null: false, default: true, index: true
      t.column :host_provider, :host_providers, null: false, index: true
      t.belongs_to :video
      t.timestamps
    end
  end
end
