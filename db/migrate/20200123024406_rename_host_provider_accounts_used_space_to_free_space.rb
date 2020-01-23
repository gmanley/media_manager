class RenameHostProviderAccountsUsedSpaceToFreeSpace < ActiveRecord::Migration[6.0]
  def change
    rename_column :host_provider_accounts, :used_space, :free_space
  end
end
