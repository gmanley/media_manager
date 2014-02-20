class VideoProcessor
  include Sidekiq::Worker

  def perform(video_path)
    video = Video.find_or_create_by!(file_path: video_path)
    VideoMetadataWorker.new.perform(video.id.to_s)
    SnapshotsWorker.perform_async(video.id.to_s)
  end
end
