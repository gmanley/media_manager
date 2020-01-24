class RenameHostProviderAccountsUsedSpaceToFreeSpace < ActiveRecord::Migration[6.0]
  def up
    rename_column :host_provider_accounts, :used_space, :used_storage
    change_column :host_provider_accounts, :used_storage, :bigint
    add_column :host_provider_accounts, :total_storage, :bigint
  end

  def down
    remove_column :host_provider_accounts, :total_storage
    change_column :host_provider_accounts, :used_storage, :integer
    rename_column :host_provider_accounts, :used_storage, :used_space
  end
end
