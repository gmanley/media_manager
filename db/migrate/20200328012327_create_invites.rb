class CreateInvites < ActiveRecord::Migration[6.0]
  def change
    create_table :invites, id: :uuid do |t|
      t.string :email, null: false
      t.column :role, :users_role, default: 'consumer'
      t.belongs_to :created_by_user, null: false
      t.belongs_to :redeemed_by_user, null: true
      t.datetime :redeemed_at
      t.timestamps null: false
    end
  end
end
