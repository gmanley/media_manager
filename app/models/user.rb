class User < ApplicationRecord
  include Clearance::User

  has_many :invites, class_name: 'Invite', foreign_key: 'recipient_id'
  has_many :sent_invites, class_name: 'Invite', foreign_key: 'sender_id'

  attr_accessor :invite_id

  def self.invite_only?
    Rails.application.config.settings.invite_only?
  end

  def self.minimum_role
    Roles[Rails.application.config.settings.minimum_role]
  end

  def meets_minimum_role?
    role_class >= minimum_role
  end

  def role_class
    Roles[role]
  end
end
