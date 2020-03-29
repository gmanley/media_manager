class Invite < ApplicationRecord
  belongs_to :created_by_user, required: true, class_name: 'User'
  belongs_to :redeemed_by_user, required: false, class_name: 'User'

  validates :email, presence: true
end
