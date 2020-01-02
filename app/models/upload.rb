class Upload < ApplicationRecord
  belongs_to :video
  belongs_to :host_provider
  belongs_to :host_provider_account
end
