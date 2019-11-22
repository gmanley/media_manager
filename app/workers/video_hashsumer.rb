class VideoHashsummer
  include Sidekiq::Worker

  def perform(video_id)
    video = Video.find(video_id)
    video.set_file_hash
    video.save!
  end
end
