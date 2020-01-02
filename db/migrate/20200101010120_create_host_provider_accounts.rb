class CreateHostProviderAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :host_provider_accounts do |t|
      t.string :name
      t.string :username, null: false
      t.string :password, null: false
      t.boolean :online, default: true, null: false
      t.integer :used_space, default: 0, null: false
      t.jsonb :info
      t.belongs_to :host_provider
      t.timestamps
    end
  end
end
