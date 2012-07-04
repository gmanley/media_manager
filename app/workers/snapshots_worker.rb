class SnapshotsWorker
  include Sidekiq::Worker

  def perform(video_id)
    video = Video.find(video_id)
    video.create_snapshot_index
  end
end