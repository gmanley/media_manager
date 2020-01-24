class CreateMegaAccount
  PROVIDER_NAME = :mega

  def initialize(email:, password:, name:)
    @email = email
    @password = password
    @name = name
  end

  def perform
    response = HostProviders[PROVIDER_NAME].new.create_account(
      username: @email,
      password: @password,
      name: @name
    )

    host_provider = HostProvider.find_by(name: PROVIDER_NAME)
    HostProviderAccount.create(
      username: @email,
      password: @password,
      name: @name,
      online: false,
      host_provider_id: host_provider.id,
      total_storage: host_provider.default_storage_limit,
      info: {
        verify_command: response
      }
    )
  end
end
