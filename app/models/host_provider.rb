class HostProvider < ApplicationRecord
  has_many :host_provider_accounts
  has_many :uploads
end
