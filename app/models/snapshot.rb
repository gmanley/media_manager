class Snapshot < ApplicationRecord
  belongs_to :snapshot_index

  delegate :video, to: :snapshot_index

  has_one_attached :image do |attachable|
    attachable.variant :large, resize_to_limit: [600, 600]
    attachable.variant :tiny, resize_to_fill: [75, 75, 'North']
  end

  def self.processed
    where(processed: true)
  end

  def formated_video_time
    Video.formated_duration_from_seconds(video_time)
  end

  def generate_image
    Dir.mktmpdir do |dir|
      snapshot_path = File.join(dir, "#{File.basename(video.file_path)}_snapshot#{video_time}.jpg")

      args = [
        "ffmpeg -ss #{video_time}",
        "-i #{video.file_path.shellescape}",
        "-vframes 1 -an -f rawvideo -vcodec mjpeg"
      ]
      args << "-vf scale=#{video.calculated_width}:#{video.height}" if video.non_square_pixel?
      args << "#{snapshot_path.shellescape} >/dev/null 2>&1"

      if system(args.join(' '))
        self.image.attach(
          io: File.open(snapshot_path),
          filename: File.basename(snapshot_path),
          content_type: 'image/jpeg',
          identify: false
        )
      else
        false
      end
    end
  end
end
