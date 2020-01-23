class RenameHostProviderAccountsUsedSpaceToFreeSpace < ActiveRecord::Migration[6.0]
  def up
    rename_column :host_provider_accounts, :used_space, :free_space
    change_column :host_provider_accounts, :free_space, :bigint
  end

  def down
    rename_column :host_provider_accounts, :free_space, :used_space
    change_column :host_provider_accounts, :used_space, :integer
  end
end
