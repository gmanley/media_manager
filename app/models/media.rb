require 'shellwords'
require 'digest/md5'
require 'find'

class Media
  include Mongoid::Document
  include Mongoid::Timestamps

  # has_many   :segments
  embeds_one :snapshot_index
  delegate   :snapshots, to: :snapshot_index

  field :file_metadata, type: Hash
  field :file_path,     type: String
  field :file_hash,     type: String
  field :file_name,     type: String

  before_create :set_metadata, :find_heuristic_hash
  after_create :async_generate_snapshots

  VIDEO_EXTENSIONS = ['.3gp', '.asf', '.asx', '.avi', '.flv', '.iso', '.m2t', '.m2ts', '.m2v', '.m4v',
                      '.mkv', '.mov', '.mp4', '.mpeg', '.mpg', '.mts', '.ts', '.tp', '.trp', '.vob', '.wmv', '.swf']

  def self.scan(path, limit = nil)
    files = Find.find(path).find_all {|p| FileTest.file?(p) && VIDEO_EXTENSIONS.include?(File.extname(p).downcase)}
    files = files.sample(limit) if limit
    progress_bar = ProgressBar.new('Media Scanner', files.count)
    files.each do |file_path|
      create(file_path: file_path, file_name: File.basename(file_path.mb_chars.compose.to_s))
      progress_bar.inc
    end
    progress_bar.finish
  end

  def self.formated_duration_from_seconds(duration)
    hours = (duration / 3600)
    minutes = (duration / 60) - (hours * 60)
    seconds = duration % 60
    "%02d:" % hours + "%02d:" % minutes + "%02d" % seconds
  end

  def formated_duration
    self.class.formated_duration_from_seconds(duration) if duration
  end

  def video_resolution
    @video_resolution ||= %w[width height].collect { |k| file_metadata['tracks'][0][k].gsub(/\D/, '').to_i }
  end

  def duration
    if file_metadata && match = file_metadata['duration'].match(/((?<h>\d+)h )?((?<m>\d+)mn )?((?<s>\d+)s)?/)
      @duration ||= ((match[:h].to_i || 0) * 60 * 60) + ((match[:m].to_i || 0) * 60) + match[:s].to_i
    end
  end

  protected
  def async_generate_snapshots
    SnapshotsWorker.perform_async(id)
  end

  def set_metadata
    raw_response = %x[mediainfo #{file_path.shellescape} --Output=XML]
    parsed_response = Nori.parse(raw_response)[:mediainfo][:file]
    parsed_response[:tracks] = parsed_response.delete(:track)
    general = parsed_response[:tracks].find { |track| track[:type].eql?('General') && track.delete(:type) }
    parsed_response.merge!(parsed_response[:tracks].delete(general))
    self.file_metadata = parsed_response
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