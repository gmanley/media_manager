require 'shellwords'
require 'digest/md5'
require 'find'
require 'pathname'

class Video < ApplicationRecord
  has_one :snapshot_index
  delegate :snapshots, to: :snapshot_index

  has_many :source_files
  belongs_to :primary_source_file, class_name: 'SourceFile'

  has_many :uploads

  before_create :set_name

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  # From the samples I used this value is 1.333.
  NON_SQUARE_PIXEL_ASPECT_RATIO = (1.1..)

  # This only covers 2000-2019 videos.
  # TODO: figure out a way to configure this
  ASSUMED_YEAR_CENTURY = '20'
  NUMERAL_DATE_REGEX = /
    (?<year>(20)?(01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19))
    (?<separator>\.|\-|\/)?
    (?<month>0[1-9]|1[012])
    (\k<separator>)?
    (?<day>0[1-9]|\.[1-9]|[12][0-9]|3[01])
  /x

  mappings dynamic: true do
    indexes :model_id, type: 'string', analyzer: :keyword
    indexes :name do
      indexes :name, analyzer: :snowball
      indexes :name_sortable, analyzer: :keyword
    end
    indexes :air_date, type: 'date'
    indexes :formated_air_date, type: 'string'
  end

  def self.scan(path, options = {})
    VideoScanner.new(path, options).perform
  end

  def self.formated_duration_from_seconds(duration)
    Time.at(duration).utc.strftime("%H:%M:%S")
  end

  def upload_to(provider, remote_path: nil)
    response = HostProviders[provider].new(self, remote_path: remote_path).upload
    if response.success?
      uploads.create(
        host_provider: provider,
        url: response.url,
        remote_path: response.path
      )
    end
  end

  def file_metadata
    super&.with_indifferent_access
  end

  def file_path
    SourceFile.find(primary_source_file_id).path
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
    self.class.formated_duration_from_seconds(duration.to_f) if duration
  end

  def formated_air_date
    "#{air_date.strftime('%Y.%m.%d')}" if air_date
  end

  def set_duration
    if file_metadata.present?
      self.duration = file_metadata[:general].first[:duration].to_f
    end
  end

  def non_square_pixel?
    NON_SQUARE_PIXEL_ASPECT_RATIO.cover?(pixel_aspect_ratio)
  end

  def calculated_width
    width * pixel_aspect_ratio
  end

  def height
    @height ||= file_metadata[:video].first[:height].gsub(/\D/, '').to_i
  end

  def width
    @width ||= file_metadata[:video].first[:width].gsub(/\D/, '').to_i
  end

  def pixel_aspect_ratio
    @pixel_aspect_ratio ||= file_metadata[:video].first[:pixel_aspect_ratio].to_f
  end

  def set_air_date
    match = NUMERAL_DATE_REGEX.match(name)
    if match
      # TODO: Should figure out a better way to do this
      year = match[:year]
      year.prepend(ASSUMED_YEAR_CENTURY) if year.length == 2

      self.air_date = DateTime.strptime(
        "#{year}-#{match[:month]}-#{match[:day]}",
        '%Y-%m-%d'
      )
    end
  end

  def ffmpeg
    @ffmpeg ||= FFMPEG::Movie.new(file_path)
  end

  # def as_indexed_json(options = {})
  #   {
  #     model_id:  id.to_s,
  #     air_date:  air_date,
  #     name:      name,
  #     formated_duration:  formated_duration,
  #     formated_air_date: formated_air_date
  #   }.to_json
  # end

  def set_name
    self.name = default_name
  end

  def set_metadata
    raw_response = %x[mediainfo #{file_path.shellescape} --output=XML]
    parsed_response = Nori.parse(raw_response)[:media_info][:media]

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
