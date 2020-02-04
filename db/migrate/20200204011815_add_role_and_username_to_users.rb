class AddRoleAndUsernameToUsers < ActiveRecord::Migration[6.0]
  def up
    execute <<~SQL
      CREATE TYPE users_role AS ENUM (
        'admin',
        'contributor',
        'consumer'
      );
    SQL
    add_column :users, :role, :users_role, default: 'consumer'
    add_column :users, :username, :string
  end

  def down
    remove_column :users, :username
    remove_column :users, :role
    execute <<~SQL
      DROP TYPE users_role;
    SQL
  end
end
