class User < ApplicationRecord
  include Clearance::User

  has_many :invites, class_name: 'Invite', foreign_key: 'recipient_id'
  has_many :sent_invites, class_name: 'Invite', foreign_key: 'sender_id'

  def role_class
    Roles[role]
  end
end
