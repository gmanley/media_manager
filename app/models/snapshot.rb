class Snapshot
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :snapshot_index
  delegate :video, to: :snapshot_index

  mount_uploader :image, ImageUploader

  field :video_time, type: Float
  field :processed, type: Boolean, default: false

  def self.processed
    where(processed: true)
  end

  def formated_video_time
    Video.formated_duration_from_seconds(video_time)
  end

  def generate_image
    Dir.mktmpdir do |dir|
      snapshot_path = File.join(dir, "#{File.basename(video.file_path)}_snapshot#{video_time}.jpg")

      scale_args = "-vf scale=#{video.calculated_width}:#{video.height} \\"
      if system("ffmpeg -ss #{video_time} \
                  -i #{video.file_path.shellescape} \
                  -vframes 1 -an -f rawvideo -vcodec mjpeg \
                  #{scale_args if video.non_square_pixel?}
                  #{snapshot_path.shellescape} >/dev/null 2>&1")
        self.image = File.open(snapshot_path)
      else
        false
      end
    end
  end
end
