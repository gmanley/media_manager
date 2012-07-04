require 'shellwords'
require 'digest/md5'
require 'find'
require 'pathname'

class Video
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Extensions::Hash::IndifferentAccess

  embeds_one :snapshot_index
  delegate   :snapshots, to: :snapshot_index

  field :file_metadata, type: Hash,   default: {}
  field :file_path,     type: String
  field :file_hash,     type: String
  field :name,          type: String
  field :air_date,      type: Date
  field :duration,      type: Float
  field :processed,     type: Boolean, default: false
  field :download_url,  type: String

  include Tire::Model::Search
  include Tire::Model::Callbacks

  mapping do
    indexes :_id,      index: :not_analyzed
    indexes :name,     type: 'multi_field', fields: {
      name:          { type: 'string', analyzer: 'snowball' },
      name_sortable: { type: 'string', index: :not_analyzed }
    }
    indexes :air_date, type: 'date'
    indexes :formated_air_date, type: 'string'
  end

  before_create :process!
  after_create  :create_snapshot_index

  VIDEO_EXTENSIONS = %w[.3gp .asf .asx .avi .flv .iso .m2t .m2ts .m2v .m4v .mkv
                        .mov .mp4 .mpeg .mpg .mts .ts .tp .trp .vob .wmv .swf]

  def self.scan(path, limit = nil)
    files = Find.find(path).find_all do |sub_path|
      VIDEO_EXTENSIONS.include?(File.extname(sub_path))
    end
    files = files.sample(limit) if limit

    progress_bar = ProgressBar.new('Video Scanner', files.count)
    Parallel.each(files, in_threads: 10) do |file_path|
      file_path = file_path.mb_chars.compose.to_s
      create(file_path: file_path, name: File.basename(file_path, File.extname(file_path)))
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

  def self.paginate(options = {})
    page(options[:page]).per(options[:per_page])
  end

  def process!
    set_metadata
    find_heuristic_hash
    set_duration
    self.processed = true
  end

  def formated_duration
    self.class.formated_duration_from_seconds(duration) if duration
  end

  def formated_air_date
    "#{air_date.strftime('%Y.%m.%d')}" if air_date
  end

  def filename
    display_name << File.extname(file_path)
  end

  def display_name
    "#{formated_air_date} #{name}"
  end

  def video_resolution
    if file_metadata.present?
      @video_resolution ||= [:width, :height].collect do |key|
        file_metadata[:video][0][key].gsub(/\D/, '').to_i
      end
    end
  end

  def set_duration
    if file_metadata.present? && duration = file_metadata[:general][0][:duration]
      duration.match(/((?<h>\d+)h )?((?<m>\d+)mn )?((?<s>\d+)s)?/) do |match|
        self.duration = ((match[:h].to_i || 0) * 60 * 60) + ((match[:m].to_i || 0) * 60) + match[:s].to_i
      end
    end
  end

  def to_indexed_json
    {
      _id:       _id,
      air_date:  air_date,
      name:      name,
      formated_duration:  formated_duration,
      formated_air_date: formated_air_date
    }.to_json
  end

  protected
  def set_metadata
    raw_response = %x[mediainfo #{file_path.shellescape} --output=XML]
    parsed_response = Nori.parse(raw_response)[:mediainfo][:file]
    parsed_response[:track].each do |track|
      self.file_metadata[track.delete(:type).downcase] ||= [] << track
    end
  end

  # Calculates a hash for the video using a portion of the file,
  # because large videos take forever to scan. (Taken from https://github.com/mistydemeo/metadater)
  def find_heuristic_hash
    if File.size(file_path) < 6291456  # File is too small to seek to 5MB, so hash the whole thing
      self.file_hash = Digest::MD5.hexdigest(IO.binread(file_path))
    else
      self.file_hash = Digest::MD5.hexdigest(File.open(file_path, 'rb') { |f| f.seek 5242880; f.read 1048576 })
    end
  end
end