class HostProviderAccount < ApplicationRecord
  belongs_to :host_provider
  has_many :uploads

  def client
    @client ||= HostProviders[host_provider.name].new(
      username: username,
      password: password
    )
  end

  def check_and_update_free_space
    if client.check_usage?
      update(free_space: client.status[:free_space])
    end
  end
end
