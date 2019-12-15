class VideoProcessingWorker
  include Sidekiq::Worker

  def perform(video_id)
    video = Video.find(video_id)
    video.set_metadata
    video.set_duration
    video.set_air_date
    video.save!

    VideoHashsumWorker.perform_async(video.id)
    SnapshotsWorker.perform_async(video.id)
  end
end
