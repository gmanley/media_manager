class ThumbnailWorker
  include Sidekiq::Worker

  def perform(media_id)
    media = Media.find(media_id)
    media.generate_thumbnail
  end
end