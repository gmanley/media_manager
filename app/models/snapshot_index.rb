class SnapshotIndex
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :media, class_name: 'Media'
  embeds_many :snapshots

  mount_uploader :image, ImageUploader

  field :grid_size, type: Array, default: [3, 3]

  after_create :create_snapshots, :create_index_image

  def total_snapshots
    grid_size.reduce(1, :*)
  end

  def create_snapshots
    increment = media.duration / total_snapshots

    snapshot_count, video_time = 0, 0

    until snapshot_count == total_snapshots
      snapshot = Snapshot.new

      snapshot_count += 1

      video_time += increment
      video_time = (video_time - increment / total_snapshots).floor
      snapshot.video_time = video_time

      self.snapshots << snapshot
    end
    save
  end

  def create_index_image
    a = Magick::ImageList.new
    resolution = media.video_resolution # for w/e reason this is needed for video_size to be defined

    snapshots.each do |snapshot|
      image = Magick::Image.from_blob(snapshot.image.read).first
      image.annotate(Magick::Draw.new, 0, 0, 50, 10, snapshot.formated_time) do
        self.font_family = 'Helvetica'
        self.fill = 'white'
        self.stroke = 'black'
        self.pointsize = resolution.last / 15
        self.font_weight = Magick::BoldWeight
        self.gravity = Magick::SouthEastGravity
      end

      a << image
    end

    a.montage do
      self.background_color = 'transparent'
      self.border_color = 'transparent'
      self.border_width = resolution.last / 120
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
        (a.scene += 1) rescue a.scene = 0
      end
    end

    mosaic = b.mosaic
    mosaic.background_color = 'transparent'
    mosaic_io = StringIO.new(mosaic.to_blob)
    mosaic_io.instance_eval { def original_filename; 'mosaic.png' end }
    self.image = mosaic_io
    save
  end
end