require 'shellwords'
require 'digest/md5'
require 'find'

class Media
  include Mongoid::Document
  include Mongoid::Timestamps
  #has_many    :segments
  # embeds_many :images
  mount_uploader :thumbnail, ImageUploader

  field :file_metadata,  type: Hash
  field :file_path, type: String
  field :file_hash, type: String
  field :file_name, type: String
  field :duration, type: Integer

  before_create :parse_metadata, :find_heuristic_hash
  after_create :generate_thumbnail

  VIDEO_EXTENSIONS = ['.3gp', '.asf', '.asx', '.avi', '.flv', '.iso', '.m2t', '.m2ts', '.m2v', '.m4v',
                      '.mkv', '.mov', '.mp4', '.mpeg', '.mpg', '.mts', '.ts', '.tp', '.trp', '.vob', '.wmv', '.swf']

  def self.scan(path)
    files = Find.find(path).find_all {|p| FileTest.file?(p) && VIDEO_EXTENSIONS.include?(File.extname(p).downcase)}.sample(2)
    progress_bar = ProgressBar.new('Media Scanner', files.count)
    files.each do |file_path|
      create(file_path: file_path, file_name: File.basename(file_path.mb_chars.compose.to_s))
      progress_bar.inc
    end
    progress_bar.finish
  end

  protected
  def parse_metadata
    raw_response = %x[mediainfo #{file_path.shellescape} --Output=XML]
    parsed_response = Nori.parse(raw_response)[:mediainfo][:file]
    parsed_response[:tracks] = parsed_response.delete(:track)
    general = parsed_response[:tracks].find {|track| track[:type].eql?('General') && track.delete(:type) }
    parsed_response.merge!(parsed_response[:tracks].delete(general))
    self.file_metadata = parsed_response
    set_duration
  rescue Exception => e
    Rails.logger.warn("Can't parse #{file_path} - Error: #{e}")
  end

  def set_duration
    if match = file_metadata[:duration].match(/((?<h>\d+)h )?((?<m>\d+)mn )?((?<s>\d+)s)?/)
      self.duration = ((match[:h].to_i || 0) * 60 * 60) + ((match[:m].to_i || 0) * 60) + match[:s].to_i
    end
  end

  def generate_thumbnail
    return unless duration
    Dir.mktmpdir do |dir|
      thumb_path = "#{dir}/#{File.basename(file_path).shellescape}_thumb.png"
      if system("ffmpeg -ss #{duration / 2} -i #{file_path.shellescape} -vcodec mjpeg -vframes 1 -an -f rawvideo #{thumb_path.shellescape} >/dev/null 2>&1")
        self.thumbnail = File.open(thumb_path)
      else
        Rails.logger.warn("Can't generate thumbnail for #{file_path}")
      end
    end
    save
  end

  # Calculates a hash for the video using a portion of the file,
  # because large videos take forever to scan. (Taken from https://github.com/mistydemeo/metadater)
  def find_heuristic_hash
    if File.size(file_path) < 6291456  # File is too small to seek to 5MB, so hash the whole thing
      self.file_hash = Digest::MD5.hexdigest(IO.binread(file_path))
    else
      self.file_hash = Digest::MD5.hexdigest(File.open(file_path, 'rb') { |f| f.seek 5242880; f.read 1048576 })
    end
  rescue Exception => e
    Rails.logger.warn("Can't calculate hash for #{file_path} - Error: #{e}")
  end
end
