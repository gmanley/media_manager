class Upload < ApplicationRecord
  belongs_to :video
  belongs_to :host_provider
  belongs_to :host_provider_account

  def is_up?
    host_provider_account.client.upload_valid?(self)
  end
end
