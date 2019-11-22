class SnapshotWorker
  include Sidekiq::Worker

  def perform(video_id, snapshot_time)
    video = Video.find(video_id)
    snapshot = video.snapshots.find_or_initialize_by(video_time: snapshot_time)
    if snapshot.generate_image
      snapshot.save!
      snapshot.update_attributes(processed: true)
    end
  end
end
