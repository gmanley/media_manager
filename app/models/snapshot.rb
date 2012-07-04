class Snapshot
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :snapshot_index
  delegate :video, to: :snapshot_index

  mount_uploader :image, ImageUploader

  field :video_time, type: Float

  def formated_video_time
    Video.formated_duration_from_seconds(video_time)
  end

  def generate_image
    Dir.mktmpdir do |dir|
      snapshot_path = File.join(dir, "#{File.basename(video.file_path)}_snapshot#{video_time}.png")
      if system("ffmpeg -ss #{video_time} -i #{video.file_path.shellescape} -vframes 1 -an -f rawvideo -vcodec mjpeg #{snapshot_path.shellescape} >/dev/null 2>&1")
        self.image = File.open(snapshot_path)
      else
        Rails.logger.warn("Can't generate snapshot of #{formated_video_time} for #{video.file_path}")
      end
    end
  end
end