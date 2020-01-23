class UploadVideo
  def initialize(video, provider_name, account:, remote_path: nil)
    @video = video
    @provider_name = provider_name
    @account = account
    @remote_path = remote_path
  end

  def perform
    response = @account.client.upload(@video, remote_path: @remote_path)
    if response.success?
      @video.uploads.create(
        host_provider_id: HostProvider.find_by(name: @provider_name).id,
        url: response.url,
        remote_path: response.path,
        host_provider_account_id: @account.id
      )

      @account.check_and_update_free_space
    end
  end
end
