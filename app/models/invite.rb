class Invite < ApplicationRecord
  belongs_to :sender, required: true, class_name: 'User'
  belongs_to :recipient, required: false, class_name: 'User'

  before_save :set_email_case, if: :email_changed?
  before_save :check_existing_user

  validates :email, presence: true

  def check_existing_user
    existing_user = User.find_by(email: email)
    self.recipient_id = existing_user.id if existing_user
  end

  private

  def set_email_case
    email.downcase!
  end
end
