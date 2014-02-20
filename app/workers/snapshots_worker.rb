class SnapshotsWorker
  include Sidekiq::Worker

  def perform(video_id)
    video = Video.find(video_id)
    video.create_snapshot_index.snapshot_times.each do |video_time|
      SnapshotWorker.perform_async(video_id, video_time)
    end
  end
end
