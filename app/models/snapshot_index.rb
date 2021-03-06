class SnapshotIndex < ApplicationRecord
  belongs_to :video
  has_many :snapshots

  has_one_attached :image do |attachable|
    attachable.variant :large, resize_to_limit: [600, 600]
    attachable.variant :medium, resize_to_limit: [400, 400]
  end

  def total_snapshots
    grid_size.reduce(1, :*)
  end

  def snapshot_times
    increment = video.duration.to_f / total_snapshots
    (increment..video.duration.to_f).step(increment).map do |i|
      (i - increment / total_snapshots).floor
    end
  end

  def can_create_index?
    snapshots.processed.count == total_snapshots
  end

  def create_index_image
    return false unless can_create_index?

    a = Magick::ImageList.new

    video_height = video.height
    snapshots.each do |snapshot|
      image = Magick::Image.from_blob(snapshot.image.download).first
      image.annotate(Magick::Draw.new, 0, 0, 50, 10, snapshot.formated_video_time) do
        self.font_family = 'Helvetica'
        self.fill = 'white'
        self.stroke = 'black'
        self.pointsize = video_height / 15
        self.font_weight = Magick::BoldWeight
        self.gravity = Magick::SouthEastGravity
      end

      a << image
    end

    a.montage do
      self.background_color = 'transparent'
      self.border_color = 'transparent'
      self.border_width = video_height / 120
    end

    b = Magick::ImageList.new

    page = Magick::Rectangle.new(0, 0, 0, 0)
    a.scene = 0

    x, y = grid_size.unshift

    x.times do |i|
      y.times do |j|
        b << a.scale(0.25)
        page.x = j * b.columns
        page.y = i * b.rows
        b.page = page
        # FIXME: This is a bad use of rescue
        (a.scene += 1) rescue a.scene = 0
      end
    end

    mosaic = b.mosaic
    mosaic.background_color = 'transparent'
    mosaic_io = StringIO.new(mosaic.to_blob)

    image.attach(
      io: StringIO.new(mosaic.to_blob),
      filename: 'mosaic.png',
      content_type: 'image/png',
      identify: false
    )

    save
  end
end
