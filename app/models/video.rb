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
  field :name,          type: String, default: -> { default_name }
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

  def self.scan(path, options = {})
    VideoScanner.new(path, options).perform
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

  def default_name
    [
      formated_air_date,
      File.basename(file_path, file_ext)
    ].join(' ')
  end

  def file_ext
    File.extname(file_path)
  end

  def formated_duration
    self.class.formated_duration_from_seconds(duration) if duration
  end

  def formated_air_date
    "#{air_date.strftime('%Y.%m.%d')}" if air_date
  end

  def video_resolution
    if file_metadata.present?
      @video_resolution ||= [:width, :height].collect do |key|
        file_metadata[:video].first[key].gsub(/\D/, '').to_i
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

  def ffmpeg
    @ffmpeg ||= FFMPEG::Movie.new(file_path)
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

  def set_metadata
    raw_response = %x[mediainfo #{file_path.shellescape} --output=XML]
    parsed_response = Nori.parse(raw_response)[:mediainfo][:file]
    self.file_metadata = parsed_response[:track].group_by do |track|
      track.delete(:type).downcase
    end
  end

  # Calculates a hash for the video using a portion of the file,
  def set_file_hash
    self.file_hash = if File.size(file_path) < 6.megabytes
      # File is too small to seek to 5MB, so hash the whole thing
      Digest::MD5.hexdigest(IO.binread(file_path))
    else
      Digest::MD5.hexdigest(File.open(file_path, 'rb') do |f|
        f.seek(5.megabytes) && f.read(1.megabyte)
      end)
    end
  end
end
