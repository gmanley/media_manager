require 'shellwords'
require 'digest/md5'
require 'find'

class Media
  include Mongoid::Document
  include Mongoid::Timestamps
  has_many    :segments
  # embeds_many :thumbnails
  mount_uploader :poster, ImageUploader
  mount_uploader :thumbnail, ImageUploader

  field :file_metadata, type: Hash
  field :file_path,     type: String
  field :file_hash,     type: String
  field :file_name,     type: String

  before_create :parse_metadata, :find_heuristic_hash
  after_create :async_generate_poster, :async_generate_thumbnail

  VIDEO_EXTENSIONS = ['.3gp', '.asf', '.asx', '.avi', '.flv', '.iso', '.m2t', '.m2ts', '.m2v', '.m4v',
                      '.mkv', '.mov', '.mp4', '.mpeg', '.mpg', '.mts', '.ts', '.tp', '.trp', '.vob', '.wmv', '.swf']

  def self.scan(path)
    files = Find.find(path).find_all {|p| FileTest.file?(p) && VIDEO_EXTENSIONS.include?(File.extname(p).downcase)}.sample(50)
    progress_bar = ProgressBar.new('Media Scanner', files.count)
    files.each do |file_path|
      create(file_path: file_path, file_name: File.basename(file_path.mb_chars.compose.to_s))
      progress_bar.inc
    end
    progress_bar.finish
  end

  def generate_poster
    return unless duration
    Dir.mktmpdir do |dir|
      poster_path = File.join(dir, "#{File.basename(file_path)}_poster.png")
      if system("ffmpeg -ss #{duration / 2} -i #{file_path.shellescape} -vcodec mjpeg -vframes 1 -an -f rawvideo #{poster_path.shellescape} >/dev/null 2>&1")
        self.poster = File.open(poster_path)
      else
        Rails.logger.warn("Can't generate poster for #{file_path}")
      end
    end
    save
  end

  def generate_thumbnail(grid_size = [3, 3])
    create_thumbnails(grid_size)
    combine_thumbnails(grid_size)
  ensure
    @thumbnails.each { |thumbnail| FileUtils.rm_f(thumbnail[:file_path]) } if @thumbnails
  end

  def video_resolution
    @video_resolution ||= %w[width height].collect { |k| file_metadata['tracks'][0][k].gsub(/\D/, '').to_i }
  end

  def duration
    if match = file_metadata['duration'].match(/((?<h>\d+)h )?((?<m>\d+)mn )?((?<s>\d+)s)?/)
      @duration ||= ((match[:h].to_i || 0) * 60 * 60) + ((match[:m].to_i || 0) * 60) + match[:s].to_i
    end
  end

  protected
  def async_generate_thumbnail
    ThumbnailWorker.perform_async(id)
  end

  def async_generate_poster
    PosterWorker.perform_async(id)
  end

  def create_thumbnails(grid_size)
    thumb_total = grid_size.reduce(1, :*)
    increment = duration / thumb_total

    thumb_count, video_time = 0, 0

    @thumbnails = []
    until thumb_count == thumb_total
      thumbnail = {}
      thumb_count += 1
      video_time += increment
      video_time = (video_time - increment / thumb_total).floor

      thumbnail[:file_path] = File.expand_path("#{File.basename(file_path)}_thumb#{thumb_count}.png", File.dirname(__FILE__))
      thumbnail[:video_time] = video_time

      hours = (video_time / 3600)
      minutes = (video_time / 60) - (hours * 60)
      seconds = video_time % 60
      thumbnail[:display_time] = "%02d:" % hours + "%02d:" % minutes + "%02d" % seconds

      @thumbnails << thumbnail
      system("ffmpeg -ss #{video_time} -i #{file_path.shellescape} -vframes 1 -an -f image2 #{thumbnail[:file_path].shellescape} >/dev/null 2>&1")
    end
  end

  def combine_thumbnails(grid_size)
    a = Magick::ImageList.new
    resolution = self.video_resolution # for w/e reason this is needed for video_size to be defined

    @thumbnails.each do |thumbnail|
      image = Magick::Image.read(thumbnail[:file_path]).first
      image.annotate(Magick::Draw.new, 0, 0, 50, 10, thumbnail[:display_time]) do
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
    self.thumbnail = mosaic_io
    save
  end

  def parse_metadata
    raw_response = %x[mediainfo #{file_path.shellescape} --Output=XML]
    parsed_response = Nori.parse(raw_response)[:mediainfo][:file]
    parsed_response[:tracks] = parsed_response.delete(:track)
    general = parsed_response[:tracks].find {|track| track[:type].eql?('General') && track.delete(:type) }
    parsed_response.merge!(parsed_response[:tracks].delete(general))
    self.file_metadata = parsed_response
    set_duration
  rescue StandardError => e
    Rails.logger.warn("Can't parse #{file_path} - Error: #{e}")
  end

  # Calculates a hash for the video using a portion of the file,
  # because large videos take forever to scan. (Taken from https://github.com/mistydemeo/metadater)
  def find_heuristic_hash
    if File.size(file_path) < 6291456  # File is too small to seek to 5MB, so hash the whole thing
      self.file_hash = Digest::MD5.hexdigest(IO.binread(file_path))
    else
      self.file_hash = Digest::MD5.hexdigest(File.open(file_path, 'rb') { |f| f.seek 5242880; f.read 1048576 })
    end
  rescue StandardError => e
    Rails.logger.warn("Can't calculate hash for #{file_path} - Error: #{e}")
  end
end
