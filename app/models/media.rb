require 'shellwords'
require 'digest/md5'
require 'find'
require 'pathname'

class Media
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Extensions::Hash::IndifferentAccess

  embeds_one :snapshot_index
  delegate   :snapshots, to: :snapshot_index

  field :file_metadata, type: Hash,    default: {}
  field :file_path,     type: String
  field :file_hash,     type: String
  field :name,          type: String
  field :air_date,      type: Date
  field :processed,     type: Boolean, default: false

  before_create :process!
  after_create  :create_snapshot_index

  VIDEO_EXTENSIONS = %w[.3gp .asf .asx .avi .flv .iso .m2t .m2ts .m2v .m4v .mkv
                        .mov .mp4 .mpeg .mpg .mts .ts .tp .trp .vob .wmv .swf]

  def self.scan(path, limit = nil)
    files = Find.find(path).find_all do |sub_path|
      VIDEO_EXTENSIONS.include?(File.extname(sub_path))
    end
    files = files.sample(limit) if limit

    progress_bar = ProgressBar.new('Media Scanner', files.count)
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

  def process!
    set_metadata
    find_heuristic_hash
    normalize_name
    self.processed = true
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

  def duration
    if file_metadata.present? && duration = file_metadata[:general][0][:duration]
      duration.match(/((?<h>\d+)h )?((?<m>\d+)mn )?((?<s>\d+)s)?/) do |match|
        @duration ||= ((match[:h].to_i || 0) * 60 * 60) + ((match[:m].to_i || 0) * 60) + match[:s].to_i
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