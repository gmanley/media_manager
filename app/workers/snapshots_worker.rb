class SnapshotsWorker
  include Sidekiq::Worker

  def perform(media_id)
    media = Media.find(media_id)
    media.create_snapshot_index
  end
end