class UploadVideo
  def initialize(video, provider_name, account:, remote_path: nil)
    @video = video
    @provider_name = provider_name
    @account = account
    @remote_path = remote_path
  end

  def perform
    provider_client = HostProviders[@provider_name].new(
      username: @account.username,
      password: @account.password
    )

    response = provider_client.upload(@video, remote_path: @remote_path)

    if response.success?
      @video.uploads.create(
        host_provider_id: HostProvider.find_by(name: @provider_name).id,
        url: response.url,
        remote_path: response.path,
        host_provider_account_id: @account.id
      )

      if provider_client.check_usage?
        @video.update(used_space: provider_client.status[:used_space])
      end
    end
  end
end
