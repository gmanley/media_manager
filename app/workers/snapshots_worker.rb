class SnapshotsWorker
  include Sidekiq::Worker

  def perform(video_id)
    video = Video.find(video_id)
    snapshot_index = video.snapshot_index || video.create_snapshot_index

    batch = Sidekiq::Batch.new
    batch.on(:success, SnapshotWorker, 'video_id' => video.id)
    batch.jobs do
      snapshot_index.snapshot_times.each do |video_time|
        SnapshotWorker.perform_async(video_id, video_time)
      end
    end
  end
end
