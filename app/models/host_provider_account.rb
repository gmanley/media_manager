class HostProviderAccount < ApplicationRecord
  belongs_to :host_provider
  has_many :uploads

  validates :username, presence: true
  validates :password, presence: true
  validates :host_provider, presence: true
  validates :name, presence: true, if: -> { host_provider.name == 'mega' }

  def self.online
    where(online: true)
  end

  def self.for_provider(provider)
    joins(:host_provider).where(host_providers: { name: provider })
  end

  def client
    @client ||= HostProviders[host_provider.name].new(
      username: username,
      password: password
    )
  end

  def free_storage
    total_storage - used_storage
  end

  def check_and_update_free_space
    if client.check_usage?
      update(used_storage: client.status[:used_storage])
    end
  end
end
