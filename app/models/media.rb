require 'shellwords'
require 'digest/md5'
require 'find'
require 'pathname'

class Media
  include Mongoid::Document
  include Mongoid::Timestamps

  embeds_one :snapshot_index
  delegate   :snapshots, to: :snapshot_index

  field :file_metadata, type: Hash,    default: {}
  field :file_path,     type: String
  field :file_hash,     type: String
  field :name,          type: String
  field :air_date,      type: Date
  field :duration,      type: Float
  field :processed,     type: Boolean, default: false

  include Tire::Model::Search
  include Tire::Model::Callbacks

  mapping do
    indexes :_id,      index:    :not_analyzed
    indexes :name,     analyzer: 'snowball', boost: 100
    indexes :air_date, type:     'date'
  end

  before_create :process!
  after_create  :generate_snapshots

  VIDEO_EXTENSIONS = %w[.3gp .asf .asx .avi .flv .iso .m2t .m2ts .m2v .m4v .mkv
                        .mov .mp4 .mpeg .mpg .mts .ts .tp .trp .vob .wmv .swf]

  def self.scan(path, limit = nil)
    path = Pathname(path.mb_chars.compose.to_s)
    files = path.find.find_all do |sub_path|
      sub_path.file? && VIDEO_EXTENSIONS.include?(sub_path.extname)
    end
    files = files.sample(limit) if limit

    progress_bar = ProgressBar.new('Media Scanner', files.count)
    Parallel.each(files, in_threads: 10) do |file_path|
      create(file_path: file_path, name: file_path.basename(file_path.extname))
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
    normalize_name
    set_duration
    self.processed = true
  end

  def file_metadata
    read_attribute(:file_metadata).with_indifferent_access
  end

  def formated_duration
    self.class.formated_duration_from_seconds(duration) if duration
  end

  def formated_air_date
    "[#{air_date.strftime('%Y.%m.%d')}]" if air_date
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

  def normalize_name
    # TODO: Refactor as this contains logic specific to my use case!
    old_year = /(?<year>(07|08|09|10|11|12))/
    new_year = /(?<year>(20)(07|08|09|10|11|12))/
    month = /(?<month>0[1-9]|1[012])/
    day = /(?<day>0[1-9]|[12][0-9]|3[01])/
    new_name_format = /(?<date>\[#{new_year}\.#{month}\.#{day}\])(?<title>.+)/
    old_name_format = /(?<title>.+)(?<date>\[#{month}\.#{day}\.#{old_year}\])/

    if match = name.match(new_name_format)
      self.air_date = Date.strptime(match[:date], '[%Y.%m.%d]')
      self.name = match[:title].strip
    elsif match = name.match(old_name_format)
      self.air_date = Date.strptime(match[:date], '[%m.%d.%y]')
      self.name = match[:title].strip
    end

    self.name = name.gsub(/\[soshi subs\]/i, '').strip
  end

  def to_indexed_json
    {
      _id:       _id,
      air_date:  air_date,
      file_hash: file_hash,
      name:      name
    }.to_json
  end

  protected
  def generate_snapshots
    # SnapshotsWorker.perform_async(id)
    create_snapshot_index # Use this instead of the above when debugging
  end

  def set_metadata
    raw_response = %x[mediainfo #{file_path.shellescape} --output=XML]
    parsed_response = Nori.parse(raw_response)[:mediainfo][:file]
    parsed_response[:track].each {|track| self.file_metadata[track.delete(:type).downcase] ||= [] << track }
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