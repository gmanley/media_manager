class VideoMetadataWorker
  include Sidekiq::Worker

  def perform(video_id)
    video = Video.find(video_id)
    video.set_metadata
    video.set_duration
    video.save!
  end
end
