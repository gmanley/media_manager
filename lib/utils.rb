module Utils
  class GDriveURLRetriever
    DOWNLOAD_BASE_URI = 'https://docs.google.com/uc?export=download&confirm=no_antivirus&id='.freeze

    def initialize(email, password)
      @session = GoogleDrive.login(email, password)
    end

    def start
      videos = Video.all
      videos.each do |m|
        set_download_url(m)
      end
    end

    private
    def set_download_url(video)
      file_name = File.basename(video.file_path)
      file = @session.file_by_title(file_name)
      resource_id = file.document_feed_entry.search("//gd:resourceId").first.text.gsub('file:', '')
      download_url = DOWNLOAD_BASE_URI + resource_id
      video.update_attribute(:download_url, download_url)
    rescue StandardError => e
      puts e.message
      puts "The record with the following id failed to have its download url set: #{video.id}"
    end
  end

  def self.normalize_video_name(video)
    old_year = /(?<year>(07|08|09|10|11|12))/
    new_year = /(?<year>(20)(07|08|09|10|11|12))/
    month = /(?<month>0[1-9]|1[012])/
    day = /(?<day>0[1-9]|[12][0-9]|3[01])/
    new_name_format = /(?<date>\[#{new_year}\.#{month}\.#{day}\])(?<title>.+)/
    old_name_format = /(?<title>.+)(?<date>\[#{month}\.#{day}\.#{old_year}\])/

    if match = video.name.match(new_name_format)
      video.air_date = Date.strptime(match[:date], '[%Y.%m.%d]')
      video.name = match[:title].strip
    elsif match = name.match(old_name_format)
      video.air_date = Date.strptime(match[:date], '[%m.%d.%y]')
      video.name = match[:title].strip
    end

    video.name = video.name.gsub(/\[soshi subs\]/i, '').strip
  end
end