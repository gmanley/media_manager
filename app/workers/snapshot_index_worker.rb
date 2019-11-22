class SnapshotIndexWorker
  include Sidekiq::Worker

  def perform(video_id)
    video = Video.find(video_id)
    video.snapshot_index.create_index_image
    video.save!
  end
end
